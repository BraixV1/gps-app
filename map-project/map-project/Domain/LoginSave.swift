//
//  LoginSave.swift
//  map-project
//
//  Created by Brajan Kukk on 25.12.2024.
//

import SwiftData
import Foundation


// Internal model
@Model
class LoginSave: ObservableObject {
    var Id: UUID
    var token: String
    var status: String
    var firstName: String
    var lastName: String
    
    var hasPro: Bool
    
    init(id: UUID? = nil, token: String , status: String, firstName: String, lastName: String, hasPro: Bool = false) {
        self.Id = id ?? UUID()
        self.token = token
        self.status = status
        self.firstName = firstName
        self.lastName = lastName
        self.hasPro = false
    }
    
}
