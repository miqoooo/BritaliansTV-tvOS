//
//  Response.swift
//  BritaliansTV
//
//  Created by miqo on 06.11.23.
//

import Foundation

struct ErrorResponse: Codable {
    struct DataModel: Codable {
        let status: Int
    }
    
    let code: String
    let message: String
    let data: DataModel
}
