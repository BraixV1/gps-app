//
//  Response.swift
//  map-project
//
//  Created by Brajan Kukk on 25.12.2024.
//

struct ResultObject<rObject: Decodable> {
    var data: rObject?
    var errors: [String]?
    
    
    init(data: rObject?, errors: [String]?) {
        self.data = data
        self.errors = errors
    }
    
}
