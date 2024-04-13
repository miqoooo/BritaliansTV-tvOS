//
//  Endpoints.swift
//  BritaliansTV
//
//  Created by miqo on 07.11.23.
//

import Foundation

enum Endpoint {
    case CONTENT
    case BRANDS
    case HUMANS
    case STATES
    
    case BTV_ADS
    
    func path() -> String {
        switch self {
        case .CONTENT:
            return "uniquerss.rss"
        case .BRANDS:
            return "pages/brands.rss"
        case .HUMANS:
            return "pages/humans.rss"
        case .STATES:
            return "pages/states.rss"
            
        case .BTV_ADS:
            return "wp-content/uploads/MRSS/btvads_appletv.xml"
        }
    }
}
