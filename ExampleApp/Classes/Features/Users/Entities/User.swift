//
//  User.swift
//  TypiCodeUsers
//
//  Created by Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Double
    let name: String
    let username: String
    let email: String
    let address: Address
    
    var fullAddress: String {
        return "\(self.address.street) \(self.address.suite) - \(self.address.city) ,\(self.address.zipcode) "
    }
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}
