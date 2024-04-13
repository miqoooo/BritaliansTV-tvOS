//
//  MediaItemModel.swift
//  BritaliansTV
//
//  Created by miqo on 10.11.23.
//

import Foundation

extension ItemModel: Identifiable {
    var id: String {
        return self.CK_id ?? UUID().uuidString
    }
    
    var title: String {
        return self.CK_title ?? ""
    }
    
    var link: String {
        return self.CK_link ?? ""
    }
    
    var isSeries: Bool { return self.CK_content?.lowercased() == "series" }
    var isVideo: Bool { return self.CK_content?.lowercased() == "video" }
    var isList: Bool { return self.CK_content?.lowercased() == "list"}
    
    var logoURL: URL? {
        var logoPath = self.CK_serie_page_image
        if logoPath == nil { logoPath = self.CK_serieslogo }
        
        if let logo = logoPath {
            return URL(string: logo)
        }
        return nil
    }
    
    var trailerURL: String? {
        if isSeries, !(self.CK_serie_trailer_url?.isEmpty ?? true) {
            return self.CK_serie_trailer_url
        } else if !(self.CK_trailer_url?.isEmpty ?? true) {
            return self.CK_trailer_url
        }
        return nil
    }
    
    var description: String {
        return self.CK_description ?? self.CK_series_category_to_show ?? ""
    }
    
    var seasonCount: Int {
        return self.CK_series?.season?.count ?? 0
    }
    
    var releaseYear: String {
        return self.CK_releaseyear ?? ""
    }
    
    var duration: String {
        return self.CK_duration ?? ""
    }
    
    var backdrop: String {
        return self.CK_thumbnail_image169 ?? self.CK_thumbnail169 ?? ""
    }
    
    var poster: String {
        return self.CK_thumbnail_image ?? self.starData?.details_thumbnail ?? self.CK_mediaContent?.thumbnail?.url ?? "" 
    }
    
    var starData: RowItemsModel? {
        var rowData: RowItemsModel? = nil
        
        var rowDataList: [RowItemsModel] = []
        for row in self.CK_video_details_row ?? [] {
            if row.title?.lowercased() == "stars" {
                rowDataList = row.row_items ?? []
                break
            }
        }
        
        for item in rowDataList {
            if item.details_name == self.title {
                rowData = item
                break
            }
        }
        
        return rowData
    }
    
    var seasons: [RowModel] {
        return self.CK_series?.season?.compactMap({ item in
            RowModel(title: item.title, items: item.items)
        }) ?? []
    }
    
    var videoRow: [RowModel] {
        if let rowData = self.CK_video_details_row?.reduce(RowModel(title: "", items: []), { result, rowItem in
            let resultTitle = result.title!
            let rowItemTitle = rowItem.title ?? ""
            
            let title = resultTitle + (resultTitle.isEmpty ? rowItemTitle : ",\(rowItemTitle)")
            let itemList = (result.items ?? []) + (rowItem.row_items?.compactMap({ ItemModel(rowItemModel: $0)}) ?? [])
            return RowModel(title: title, items: itemList)
        }) {
            return [rowData]
        }
        
        return []
    }
}

extension ItemModel {
    init(rowItemModel: RowItemsModel) {
        self.CK_title = rowItemModel.details_name
        self.CK_thumbnail_image = rowItemModel.details_thumbnail
        self.CK_thumbnail_image169 = rowItemModel.details_thumbnail169
        self.CK_serie_page_image = rowItemModel.details_logo
        self.CK_description = rowItemModel.details_description
        
        self.CK_id = UUID().uuidString
        self.CK_content = "RowItemModel"
        
        self.CK_thumbnail169 = nil
        self.CK_serie_trailer_url = nil
        self.CK_series_category_to_show = nil
        self.CK_series = nil
        
        self.CK_link = nil
        self.CK_trailer_url = nil
        self.CK_releaseyear = nil
        self.CK_serieslogo = nil
        self.CK_duration = nil
        
        self.CK_video_details_row = nil
        
        self.CK_pubDate = nil
        //self.CK_guid = nil
        self.CK_mediaContent = nil
    }
}

extension ItemModel: Equatable {
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ItemModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)   
    }
}

extension ItemModel {
    var prettyPrint: String {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            if let jsonString = String(data: data, encoding: .utf8) {
                return jsonString
            }
        } catch {
            return "Error encoding to JSON: \(error)"
        }
        return "\(type(of: self))"
    }
}

