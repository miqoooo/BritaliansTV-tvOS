//
//  HomepageModel.swift
//  BritaliansTV
//
//  Created by miqo on 07.11.23.
//

import Foundation

struct RssModel: Codable {
    let channel: ChannelModel
}

struct ChannelModel: Codable {
    let title: String?
    let link: String?
    let description: String?
    let language: String?
    let pubDate: String?
    let image: ImageModel?
    let rows: [RowModel]?
    
    enum CodingKeys: String, CodingKey {
        case title, link, description, language, pubDate, image
        case rows = "row"
    }
}

struct ImageModel: Codable {
    let title: String?
    let url: String?
    let width: String?
    let height: String?
}

struct RSSFeedModel: Decodable {
    var rows: [RowItemsModel]?

    enum CodingKeys: String, CodingKey {
        case rows = "row_items"
    }
}

struct RowModel: Codable {
    let title: String?
    let items: [ItemModel]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case items = "item"
    }
}
