//
//  NetworkManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 30.11.2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://sportmap.akaver.com/api/v1.0/account"
    
    // Authentication
    func registerUser(user: User, completion: @escaping (Result<String, Error>) -> Void) {
           let registerURL = URL(string: "\(baseURL)/register")!
        print("Register URL: \(registerURL)")

           let requestBody: [String: Any] = [
               "email": user.email,
               "password": user.password,
               "lastName": user.lastName,
               "firstName": user.firstName
           ]
           
        performRequest(url: registerURL, method: "POST", body: requestBody) { result in
                switch result {
                case .success(let responseString):
                    print("Registration successful. Response: \(responseString)")
                    completion(.success(responseString))
                case .failure(let error):
                    print("Registration failed. Error: \(error)")
                    completion(.failure(error))
                }
            }
       }
    
    func loginUser(user: User, completion: @escaping (Result<String, Error>) -> Void) {
        let loginURL = URL(string: "\(baseURL)/login")!
        let requestBody: [String: Any] = [
            "email": user.email,
            "password": user.password
        ]
        
        performRequest(url: loginURL, method: "POST", body: requestBody, completion: completion)
    
    }
    
    private func performRequest(url: URL, method: String, body: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Data not received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let token = json?["token"] as? String {
                    completion(.success(token))
                } else {
                    // Adjust error handling based on your API response structure
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func startNewSession(session: Session, completion: @escaping (Result<Session, Error>) -> Void) {
        let startSessionURL = URL(string: "\(baseURL)/GpsSessions")!
        let requestBody: [String: Any] = [
            "name": session.name,
            "description": session.description,
            "recordedAt": session.recordedAt,
            "minSpeed": session.minSpeed,
            "maxSpeed": session.maxSpeed
        ]
        
        performRequest(url: startSessionURL, method: "POST", body: requestBody) { (result: Result<String, Error>) in
            switch result {
            case .success(let responseString):
                // Assuming your API response contains a string representation of the session or session ID.
                // You may need to parse the response accordingly.
                if let responseData = responseString.data(using: .utf8),
                   let decodedSession = try? JSONDecoder().decode(Session.self, from: responseData) {
                    completion(.success(decodedSession))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Locations
    func getLocationTypes(completion: @escaping (Result<[Location], Error>) -> Void) {
        // Implement get location types request
    }

    func postLocationUpdate(location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement post location update request
    }
}




