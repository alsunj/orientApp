//
//  User.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//
//

import Foundation
import SwiftData

class User: Codable {
  var email: String
  var password: String
  var firstName: String?
  var lastName: String?
  var jwtToken: String?
  var sessionIds: [String] = []
    init(user: User) {
         self.email = user.email
         self.password = user.password
         self.firstName = user.firstName
         self.lastName = user.lastName
         self.jwtToken = user.jwtToken
         self.sessionIds = user.sessionIds
    }

    init(email: String, password: String) {
        self.email = email
        self.password = password
        self.sessionIds = []
  }

  // Additional initializer for registration
  convenience init(email: String, password: String, firstName: String, lastName: String, jwtToken: String, sessionIds: [String]) {
      self.init(email: email, password: password)
      self.firstName = firstName
      self.lastName = lastName
      self.jwtToken = jwtToken
      self.sessionIds = sessionIds
  }

  // Additional initializer for login
  convenience init(email: String, password: String, jwtToken: String) {
      self.init(email: email, password: password)
      self.jwtToken = jwtToken
  }
}

@Model
class UserModel {
   var id: UUID?
   var email: String
   var password: String
   var firstName: String
   var lastName: String
   var jwtToken: String
   var sessionIds: [String] = []

   init(user: User) {
       self.email = user.email
       self.password = user.password
       self.firstName = user.firstName!
       self.lastName = user.lastName!
       self.jwtToken = user.jwtToken!
       self.sessionIds = user.sessionIds
   }
}



