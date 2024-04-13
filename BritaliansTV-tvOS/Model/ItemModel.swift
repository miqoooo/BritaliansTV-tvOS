//
//  ItemModel.swift
//  BritaliansTV
//
//  Created by miqo on 09.11.23.
//

import Foundation
import XMLCoder

import Foundation

struct ItemModel: Codable {
    let CK_id: String?
    let CK_title: String?
    var CK_content: String?
    
    let CK_thumbnail_image: String?
    let CK_thumbnail_image169: String?
    let CK_thumbnail169: String?
    
    let CK_serie_page_image: String?
    let CK_serie_trailer_url: String?
    let CK_series_category_to_show: String?
    var CK_series: SeriesModel?
    
    let CK_link: String?
    let CK_description: String?
    let CK_trailer_url: String?
    let CK_releaseyear: String?
    let CK_serieslogo: String?
    let CK_duration: String?
    
    let CK_video_details_row: [VideoDetailsRowModel]?
    
    let CK_pubDate: String?
    //let CK_guid: GuideModel
    let CK_mediaContent: MediaContentModel?
    
    private enum CodingKeys: String, CodingKey {
        case CK_id = "id"
        case CK_title = "title"
        case CK_content = "content"
        case CK_thumbnail_image = "thumbnail_image"
        case CK_thumbnail_image169 = "thumbnail_image169"
        case CK_thumbnail169 = "thumbnail169"
        case CK_serie_page_image = "serie_page_image"
        case CK_serie_trailer_url = "serie_trailer_url"
        case CK_series_category_to_show = "series_category_to_show"
        case CK_series = "series"
        case CK_link = "link"
        case CK_description = "description"
        case CK_trailer_url = "trailer_url"
        case CK_releaseyear = "releaseyear"
        case CK_serieslogo = "serieslogo"
        case CK_duration = "duration"
        case CK_video_details_row = "video_details_row"
        case CK_pubDate = "pubDate"
        //case CK_guid
        case CK_mediaContent = "media:content"
    }
}


struct MediaContentModel: Codable {
    struct MediaThumbnailModel: Codable {
        let url: String?
    }
    
//    let channels: String?
//    let bitrate: String?
//    let duration: String?
//    let fileSize: String?
//    let framerate: String?
//    let height: String?
//    let type: String?
//    let width: String?
//    let isDefault: String?
//    let url: String?
    
    let description: String?
    let keywords: String?
    let thumbnail: MediaThumbnailModel?
    let title: String?
    
    private enum CodingKeys: String, CodingKey {
        case description = "media:description"
        case keywords = "media:keywords"
        case thumbnail = "media:thumbnail"
        case title = "media:title"
    }
}

struct SeriesModel: Codable {
    var season: [SeasonModel]?
}

struct SeasonModel: Codable {
    var title: String?
    var id: Int?
    var items: [ItemModel]?
    
    enum CodingKeys: String, CodingKey {
        case title, id
        case items = "item"
    }
}

struct VideoDetailsRowModel: Codable {
    let title: String?
    let row_items: [RowItemsModel]?
}

struct RowItemsModel: Codable {
    let details_name: String?
    let details_thumbnail: String?
    let details_thumbnail169: String?
    
    let details_logo: String?
    let details_description: String?
    
    //HUMANS
    let details_profession: String?
    let details_bio: String?
    let details_state_origin: String?
}
