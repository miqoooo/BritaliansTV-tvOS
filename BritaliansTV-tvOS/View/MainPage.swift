//
//  MainPage.swift
//  BritaliansTV
//
//  Created by miqo on 07.11.23.
//

import SwiftUI
import Kingfisher

struct MainPage: View {
    enum FocusFields: Hashable {
        case menu
        case fromMenu
        case fromContent
        case collection(Int, Int)
        
        var stringRepresentation: String {
            switch self {
            case .menu: return "menu"
            case .fromMenu: return "fromMenu"
            case .fromContent: return "fromContent"
            case .collection(let row, let col):
                return "collection_\(row)_\(col)"
            }
        }
    }
    
    @EnvironmentObject var appVM: ApplicationVM
    @EnvironmentObject var playerVM: PlayerVM
    @EnvironmentObject var mainPageVM: MainPageVM
    @EnvironmentObject var contentVM: ContentPageVM
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @StateObject var menuVM = MenuVM()
    
    @FocusState var focus: FocusFields?
    
    @State var lastFocus: FocusFields? = .collection(0, 0)
    @State var contentOffset: CGFloat = 120
    
    var body: some View {
        ZStack {
            mainPageContent()
        }
//        .navigationDestination(item: $contentVM.selectedSeason, destination: { item in
//            SeasonPageContent()
//                .environmentObject(contentVM)
//                .environmentObject(playerVM)
//        })
//        .navigationDestination(item: $contentVM.selectedVideo, destination: { _ in
//            VideoPageContent(mediaItem: $contentVM.selectedVideo)
//                .environmentObject(contentVM)
//                .environmentObject(playerVM)
//        })
        .task(loadData)
        
        .onChange(of: focus, performAction: onFocusChange)
        .onChange(of: menuVM.opened, performAction: onMenuOpenClose)
        .onChange(of: menuVM.selection, performAction: onMenuSelection)
        .onChange(of: mainPageVM.loading, performAction: onDataLoaded)
        
        .defaultFocus($focus, .collection(0, 0))
        .onExitCommand(perform: { appVM.exitPresented = true })
        
        .environmentObject(menuVM)
    }
    
    @ViewBuilder
    func mainPageContent() -> some View {
        ZStack(alignment: .topLeading, content: {
            HStack {
                MenuView()
                    .focused($focus, equals: .menu)
                    .focusSection()
                //Spacer()
            }
            
            LoadingView(loading: mainPageVM.loading)
                .opacity(mainPageVM.loading ? 1 : 0)
            
            ZStack {
                Rectangle()
                    .frame(maxWidth: 1, maxHeight: .infinity)
                    .focusable().focused($focus, equals: .fromMenu)
                    .offset(x: contentOffset + 10).opacity(0)
                Rectangle()
                    .frame(maxWidth: 1, maxHeight: .infinity)
                    .focusable().focusable().focused($focus, equals: .fromContent)
                    .offset(x: contentOffset + 20).opacity(0)
                
                MainPageContent(focus: $focus)
                    .focusSection()
                    .offset(x: contentOffset + 50)
                    .opacity(mainPageVM.loading ? 0 : 1)
            }
            .opacity(mainPageVM.loading ? 0 : 1)
        })
        .animation(.linear(duration: 0.3), value: menuVM.opened)
    }
    
    @Sendable 
    @MainActor
    func loadData() async {
        
        if !appVM.dataLoaded {
            Task {
                await mainPageVM.loadData()
                
                playerVM.adData = mainPageVM.adData
                appVM.dataLoaded = true
            }
        }
    }
    
    func onDataLoaded(_: Bool, newValue: Bool) {
        if newValue == false {
            focus = .collection(0, 0)
            menuVM.isFocusable = true
        }
    }
    
    func onMenuSelection(oldSelection: MenuItem, newSelection: MenuItem) {
        if case .exit = newSelection {
            appVM.exitPresented = true
        } else {
            contentVM.currentItem = nil
            mainPageVM.onMenuSelection(selection: newSelection)
        }
        
        menuVM.opened = false
    }
    
    func onMenuOpenClose(oldValue: Bool, newValue: Bool) {
        print("onMenuOpenClose old: \(oldValue) | new: \(newValue)")
        if newValue == false {
            focus = lastFocus
            withAnimation(.linear(duration: 0.3)) {
                contentOffset = 120
            }
        } else if newValue == true, oldValue == false {
            withAnimation(.linear(duration: 0.3)) {
                contentOffset = 350
            }
        }
    }
    
    func onFocusChange(oldFocus: FocusFields?, newFocus: FocusFields?) {
        //print("focus old: \(oldFocus?.stringRepresentation ?? "nil") | new: \(newFocus?.stringRepresentation ?? "nil")")
        
        switch newFocus {
        case .collection(_, _):
            lastFocus = newFocus
            //print("lastFocus", lastFocus!.stringRepresentation)
            
        case .fromMenu:
            focus = lastFocus
            
        case .fromContent:
            focus = .menu
            
        default:
            break
        }
    }
}
