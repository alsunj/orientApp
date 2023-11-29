//
//  User.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//

import Foundation

struct User {
    var userId: UUID
    var firstName: String
    var lastName: String
    var email: String
    var passwordHash: String
    var salt: String
}
