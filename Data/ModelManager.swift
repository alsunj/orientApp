//
//  ModelManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 09.01.2024.
//

import Foundation
import SwiftData

class ModelContainers: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var users: [UserModel] = []
    @Published var modelContext: ModelContext?

    func setModelContext() {
        self.modelContext = modelContext
    }

    // Method to fetch all sessions
    func fetchAllSessions() async {
        do {
            var fetchDescriptor = FetchDescriptor<Session>()
            sessions = try modelContext?.fetch(fetchDescriptor) ?? []
        } catch {
            // Handle the fetch error
            print("Error fetching sessions: \(error)")
        }
    }

    // Method to fetch all users
    func fetchAllUsers() async {
        do {
            var fetchDescriptor = FetchDescriptor<UserModel>()
            users = try modelContext?.fetch(fetchDescriptor) ?? []
        } catch {
            // Handle the fetch error
            print("Error fetching users: \(error)")
        }
    }
}
