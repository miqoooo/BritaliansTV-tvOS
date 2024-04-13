//
//  APIError.swift
//  BritaliansTV
//
//  Created by miqo on 07.11.23.
//

import Foundation
import SwiftUI

enum APIError: Error, CustomNSError {
    case invalidResponse
    case invalidRequest
    case invalidEndpoint
    case decodingError(Error)
    case internalError
    case maintenanceApi
    case contentRemoved
    case unauthorized
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse:
            return "Invalid Response"
        case .invalidRequest:
            return "Invalid Request"
        case .invalidEndpoint:
            return "Invalid Endpoint"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .internalError:
            return "The server encountered an internal error () that prevented it from fulfilling this request"
        case .maintenanceApi:
            return "The API is undergoing maintenance. Try again later."
        case .contentRemoved:
            return "This content has been removed from database."
        case .unauthorized:
            return "Access to the requested resource is unauthorized (HTTP 401). Please provide valid credentials or authenticate to proceed."
        case .unknown(let errorMessage):
            return "Message: \(errorMessage)"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }

}
