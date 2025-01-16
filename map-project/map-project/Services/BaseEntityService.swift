//
//  BaseEntityService.swift
//  map-project
//
//  Created by Brajan Kukk on 25.12.2024.
//

import Foundation

class BaseEntityService<TEntity: Codable, TResponse: Decodable>: BaseService {
    private var params: [String: String] = [:]
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601 // Encode dates as Unix timestamps
        return encoder
    }()
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let iso8601Formatter = ISO8601DateFormatter()
            iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            // Attempt to parse with fractional seconds
            if let date = iso8601Formatter.date(from: dateString) {
                return date
            }
            
            // Fall back to a formatter without fractional seconds
            iso8601Formatter.formatOptions = [.withInternetDateTime]
            if let date = iso8601Formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        })
        return decoder
    }()

    
    func getAll(queryParams: [String: String] = [:]) async -> ResultObject<[TResponse]> {
        var urlComponents = URLComponents(string: baseUrl)!
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let request = createRequest(url: urlComponents.url!, method: "GET")
        return await performRequest(request)
    }
    
    func get(id: String) async -> ResultObject<TResponse> {
        let url = URL(string: "\(baseUrl)/\(id)")!
        let request = createRequest(url: url, method: "GET")
        return await performRequest(request)
    }
    
    func create(data: TEntity) async -> ResultObject<TResponse> {
        let url = URL(string: baseUrl)!
        var request = createRequest(url: url, method: "POST")
        request.httpBody = try? jsonEncoder.encode(data) // Use configured encoder
        return await performRequest(request)
    }
    
    func edit(data: TEntity, id: String) async -> ResultObject<TResponse> {
        let url = URL(string: "\(baseUrl)/\(id)")!
        var request = createRequest(url: url, method: "PUT")
        request.httpBody = try? jsonEncoder.encode(data) // Use configured encoder
        return await performRequest(request)
    }
    
    func delete(id: String) async -> ResultObject<TResponse> {
        let url = URL(string: "\(baseUrl)/\(id)")!
        let request = createRequest(url: url, method: "DELETE")
        return await performRequest(request)
    }
    
    private func createRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    private func performRequest<T: Decodable>(_ request: URLRequest) async -> ResultObject<T> {
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return ResultObject(data: nil, errors: ["Invalid response"])
            }
            
            if httpResponse.statusCode < 300 {
                // Successful response, decode the data into the expected type
                let decoded = try jsonDecoder.decode(T.self, from: data) // Use configured decoder
                return ResultObject(data: decoded, errors: nil)
            } else {
                // Error response, try to decode the error message
                if let errorMessages = try? jsonDecoder.decode(ErrorResponse.self, from: data) {
                    return ResultObject(data: nil, errors: errorMessages.messages)
                } else {
                    return ResultObject(data: nil, errors: [self.handleError(response: httpResponse, data: data)])
                }
            }
        } catch {
            return ResultObject(data: nil, errors: [self.handleError(error: error)])
        }
    }
    
    private func handleError(error: Error) -> String {
        return "An error occurred: \(error.localizedDescription)"
    }
    
    private func handleError(response: HTTPURLResponse, data: Data?) -> String {
        if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
            return "HTTP \(response.statusCode): \(errorMessage)"
        } else {
            return "HTTP \(response.statusCode): Unknown error"
        }
    }
}

struct ErrorResponse: Decodable {
    let messages: [String]
}
