//
//  RegisterData.swift
//  map-project
//
//  Created by Brajan Kukk on 25.12.2024.
//

struct RegisterData: Codable {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    
    init(email: String, password: String, firstName: String, lastName: String) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
}
