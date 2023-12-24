//
//  User.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//

import Foundation

struct User: Codable {
    var email: String
    var password: String
    var firstName: String?
    var lastName: String?
    var jwtToken: String?

    enum CodingKeys: String, CodingKey {
        case email
        case password
        case firstName
        case lastName
        case jwtToken
    }

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }

    // Additional initializer for registration
    init(email: String, password: String, firstName: String, lastName: String) {
        self.init(email: email, password: password)
        self.firstName = firstName
        self.lastName = lastName
    }

    // Additional initializer for login
    init(email: String, password: String, jwtToken: String) {
        self.init(email: email, password: password)
        self.jwtToken = jwtToken
    }
}


