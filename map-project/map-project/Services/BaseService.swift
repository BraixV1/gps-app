//
//  BaseService.swift
//  map-project
//
//  Created by Brajan Kukk on 25.12.2024.
//


import Foundation

class BaseService {
    private static let hostBaseURL = "https://sportmap.akaver.com/api/v1"
    let baseUrl: String
    let session: URLSession
    let headers: [String: String]
    
    init(baseUrl: String, accessToken: String? = nil) {
        self.baseUrl = BaseService.hostBaseURL + baseUrl
        self.session = URLSession.shared
        var defaultHeaders = ["Content-Type": "application/json"]
        if let token = accessToken {
            defaultHeaders["Authorization"] = "Bearer \(token)"
        }
        self.headers = defaultHeaders
    }
}
