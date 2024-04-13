//
//  APIService.swift
//  DemoApp
//
//  Created by miqo on 08.09.23.
//

import Foundation
import XMLCoder

typealias ParamType = [(name: String, value: String)]

struct APIService {
    private let decoder = XMLDecoder()
    static let shared = APIService()
    
    func buildUrl(endpoint: Endpoint, params: ParamType?, baseURL: URL!) async throws -> URL {
        let queryURL = baseURL.appendingPathComponent(endpoint.path())
        guard var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true) else { throw APIError.invalidEndpoint }
        
        if let params = params {
            components.queryItems = params.map { value in
                URLQueryItem(name: value.name, value: value.value)
            }
        }
                
        guard let finalURL = components.url else { throw APIError.invalidEndpoint }
        print("[FINAL URL]: [", finalURL, "]")
        return finalURL
    }
    
    func GET<T: Decodable>(url: URL, host: URL!) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        
        if let responseError = handleResponsesError(response: httpResponse) {
            print(responseError.localizedDescription)
            throw responseError
        }
        
        do {
            let data = try self.decoder.decode(T.self, from: data)
            return data
            
        } catch _ as DecodingError {
            let errorResponse = try self.decoder.decode(ErrorResponse.self, from: data)
            print("[ERROR MESSAGE: \(errorResponse.message)]")
            throw APIError.unknown(errorResponse.message)
        }
    }
    
//    func POST<T: Decodable>(url: URL, body: [String: Any], token: String = "") async throws -> T {
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        
//        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
//        //authorization
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
//        request.httpBody = jsonData
//        
//        let (data, response) = try await URLSession.shared.upload(for: request, from: jsonData)
//        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
//        
//        if let responseError = handleResponsesError(response: httpResponse) {
//            print(responseError.localizedDescription)
//            throw responseError
//        }
//        
//        do {
//            let data = try self.decoder.decode(T.self, from: data);
//            return data
//            
//        } catch _ as DecodingError {
//            let errorResponse = try self.decoder.decode(ErrorResponse.self, from: data)
//            print("[POST]\t\t", request)
//            print("[ERROR MESSAGE: \(errorResponse.message)]")
//            //print("[ERROR: \(error)]")
//            throw APIError.unknown(errorResponse.message)
//        }
//    }
//    
//    func DELETE<T: Decodable>(url: URL, body: [String: Any], token: String = "") async throws -> T {
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
//        
//        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
//        request.httpBody = jsonData
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
//        
//        if let responseError = handleResponsesError(response: httpResponse) {
//            print(responseError.localizedDescription)
//            throw responseError
//        }
//        
//        do {
//            let data = try self.decoder.decode(T.self, from: data);
//            return data
//            
//        } catch _ as DecodingError {
//            let errorResponse = try self.decoder.decode(ErrorResponse.self, from: data)
//            print("[DELETE]\t\t", request)
//            print("[ERROR MESSAGE: \(errorResponse.message)]")
//            //print("[ERROR: \(error)]")
//            throw APIError.unknown(errorResponse.message)
//        }
//    }
    
    private func handleResponsesError(response: HTTPURLResponse) -> APIError? {
        switch response.statusCode {
        case 200: return nil
        case 401: return .unauthorized
        case 503: return .maintenanceApi
        case 500: return .internalError
        default: return .invalidResponse
        }
    }
}
