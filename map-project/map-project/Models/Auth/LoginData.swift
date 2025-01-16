//
//  LoginData.swift
//  map-project
//
//  Created by Brajan Kukk on 25.12.2024.
//

struct LoginData: Codable {
    
    var email: String
    var password: String
    
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
}
