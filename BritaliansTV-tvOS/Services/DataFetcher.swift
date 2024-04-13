//
//  APIService.swift
//  BritaliansTV
//
//  Created by miqo on 07.11.23.
//

import Foundation

struct DataFetcher {
    public let baseURL = URL(string: "https://btv-rss.s3.eu-west-2.amazonaws.com/")!
    static let shared = DataFetcher()
    
    private let api = APIService.shared
    private init() {}
    
    func buildQuery<T: Codable>(query: T) -> String {
        do {
            let jsonQuery = try JSONEncoder().encode(query)
            if let jsonString = String(data: jsonQuery, encoding: .utf8) {
                return jsonString
            } else {
                print("Failed to convert encoded data to string.")
                return ""
            }
        } catch {
            print("Error encoding query: \(error)")
            return ""
        }
    }
    
    func GET<T: Decodable>(
        endpoint: Endpoint,
        params:  ParamType? = nil,
        host: URL? = nil
    ) async throws -> T {
        let baseURL = (host == nil ? self.baseURL : host)
        let url = try await api.buildUrl(endpoint: endpoint, params: params, baseURL: baseURL)
        
        let responseData: T = try await api.GET(url: url, host: host)
        return responseData
    }

}
