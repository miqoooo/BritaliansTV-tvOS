//
//  MainPage.swift
//  BritaliansTV
//
//  Created by miqo on 07.11.23.
//

import SwiftUI
import XMLCoder

struct MessageDataModel {
    var isError: Bool = true
    var message: String = ""
}

class MainPageVM: ObservableObject {
    private let api = DataFetcher.shared
    private var taskList: [String: Task<Void, Never>?] = [:]
    
    @Published var loading: Bool = true
    @Published var messagePresented: Bool = false
    var messageData: MessageDataModel = .init()
    
    var adData: AdModel? = nil
    var adTimer: Timer? = nil
    
    var data: ChannelModel? = nil
    var allItems: [ItemModel] = []
    
    var rowData: [RowModel] = []
    
    func onMenuSelection(selection: MenuItem) {
        for task in taskList {
            print("Cancelling task: ", task.key)
            task.value?.cancel()
        }
        self.taskList = [:]
        //self.data = nil
        
        self.loading = true
        executeTask(taskIdPrefix: selection.name) { @MainActor in
            switch selection {
            case .home:
                try await self.loadHomeData()
                
            case .states:
                try await self.loadContent(title: "States", endpoint: .STATES)
                
            case .humans:
                try await self.loadContent(title: "Humans", endpoint: .HUMANS)
                
            case .brands:
                try await self.loadContent(title: "Brands", endpoint: .BRANDS)
                
            default: break;
            }
        }
    }
    
    @MainActor
    func loadData() async {
        do {
            try await self.loadAds()
            try await self.loadHomeData()
            try await self.loadAds()
        } catch {
            print("[ERROR]: [", error, "]")
            self.messageData = MessageDataModel(
                isError: true,
                message: error.localizedDescription
            )
            DispatchQueue.main.async {
                self.messagePresented = true
            }
        }
    }
    
    @MainActor
    private func loadHomeData() async throws {
        if Task.isCancelled { return }
        
        let rssData: RssModel = try await api.GET(endpoint: .CONTENT)
        print("[SUCCESS loadMainPageData: ", rssData.channel.rows?.count ?? -1, "]")
        
        self.data = rssData.channel
        self.allItems = rssData.channel.rows?.flatMap({ $0.items ?? [] }) ?? []
        self.rowData = rssData.channel.rows ?? []
    
        DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.loading = false
            })
        }
    }
    
    @MainActor
    private func loadContent(title: String, endpoint: Endpoint) async throws {
        if Task.isCancelled { return }
        
        let rssData: RSSFeedModel = try await api.GET(endpoint: endpoint)
        print("[SUCCESS \(title): ", rssData.rows?.count ?? -1 , "]")
        
        //let itemList = rssData.rows.compactMap({ ItemModel.init(rowItemModel: $0) })
        var rowItemList: [ItemModel] = []
        
        for rowItem in rssData.rows ?? [] {
            let items = self.allItems.filter({
                $0.videoRow.contains(where: { $0.items?.contains(where: { $0.title == rowItem.details_name }) ?? false })
            })
            
            let season = SeasonModel(title: rowItem.details_name, id: UUID().hashValue, items: items)
            
            var item = ItemModel(rowItemModel: rowItem)
            item.CK_content = "list"
            item.CK_series = SeriesModel(season: [season])
            rowItemList.append(item)
        }
        
        let rowData = RowModel(title: title, items: rowItemList)
        
        DispatchQueue.main.async {
            self.rowData = [rowData]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.loading = false
            })
            
            //self.messageData = MessageDataModel(isError: false, message: "Success")
            //self.messagePresented = true
        }
    }
    
    private func loadAds() async throws {
        let adData: AdModel = try await api.GET(endpoint: .BTV_ADS, host: URL(string: "https://britalians.tv/")!)
        
        DispatchQueue.main.async { @MainActor in
            print("[SUCCESS loadAds: ", adData.ad_interval ?? "", "]")
            self.adData = adData
            
            //self.messageData = MessageDataModel(isError: true, message: "Error message")
            //self.messagePresented = true
        }
    }
    
    private func executeTask(taskIdPrefix: String = "", _ function: @escaping () async throws -> Void) {
        let task = Task {
            do {
                try await function()
            } catch {
                print("[ERROR]: [", error, "]")
                self.messageData = MessageDataModel(
                    isError: true,
                    message: error.localizedDescription
                )
                
                DispatchQueue.main.async {
                    self.messagePresented = true
                }
            }
        }
        
        let taskId = taskIdPrefix + "_" + UUID().uuidString
        self.taskList[taskId] = task
    }
}
