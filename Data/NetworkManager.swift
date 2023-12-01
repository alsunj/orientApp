//
//  NetworkManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 30.11.2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://sportmap.akaver.com/api/v1.0"
    private let registerEndpoint = "/account/register"
    private let loginEndpoint = "/account/login"
    private let gpsSessionsEndpoint = "/GpsSessions"
    
    @Published var isLoading : Bool = false
    @Published var savedSessionId: String? = nil
    @Published var createSessionSuccess : Bool = false
    @Published var savedUser: User? = nil
    @Published var registeredUser: User? = nil

    
    enum GpsSessionType { case walking, running }
    enum LocationType { case location, checkPoint, wayPoint }
    
    func register(firstName: String, lastName: String, email: String, password: String) async {
        isLoading = true
        let urlString = "\(baseURL)\(registerEndpoint)"
        let data = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password,
        ]
        
        guard let url = URL(string: urlString) else {
            print("unable to make string: \(urlString) to URL object")
            isLoading = false
            return
        }
        guard let encoded = try? JSONEncoder().encode(data) else {
            print("Failed to encode data: \(data)")
            isLoading = false
            return
        }
        
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: req, from: encoded)
            
            guard let res = response as? HTTPURLResponse else {
                print("Invalid response")
                isLoading = false
                
                return
            }
            
            if res.statusCode == 200 {
                // Process the successful response
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("json as data from register: \(json)")
                    
                    let token = json["token"] as! String

                    registeredUser = User(
                        email: email,
                        password: password,
                        firstName: firstName,
                        lastName: lastName,
                        jwtToken: token

                    )
                    Manager.shared.saveUserToUserDefaults(user: registeredUser!, forKey: token)
                    print("Token: \(token)")
                    
                    isLoading = false
                }
            } else if res.statusCode == 404 {
                print("User with this email already exists!")
            } else {
                
                print("HTTP Status Code: \(res.statusCode)")
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                    // Handle the error using the responseString
                } else {
                    print("Failed to convert response data to string.")
                    // Handle the error appropriately
                }
                // Handle the error appropriately
            }
        } catch {
            print("Error: \(error)")
        }
        
        isLoading = false
    }
    
    func login(email: String, password: String) async -> String? {
        isLoading = true
        
        let urlString = "\(baseURL)\(loginEndpoint)"
        let data = [
            "email": email,
            "password": password
        ]
        
        guard let url = URL(string: urlString) else {
            print("unable to make string: \(urlString) to URL object")
            isLoading = false
            return nil
        }
        guard let encoded = try? JSONEncoder().encode(data) else {
            print("Failed to encode data: \(data)")
            isLoading = false
            return nil
        }
        
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: req, from: encoded)
            
            guard let res = response as? HTTPURLResponse else {
                print("Invalid response")
                isLoading = false
                return nil
            }
            
            if res.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("json data from login: \(json)")
                    
                    let token = json["token"] as! String
                    
                    print("Token: \(token)")
                
                    isLoading = false
                    return token
                }
            } else {
                print("HTTP Status Code: \(res.statusCode)")
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                    // Handle the error using the responseString
                } else {
                    print("Failed to convert response data to string.")
                    // Handle the error appropriately
                }
                // Handle the error appropriately
            }
        } catch {
            print("Error: \(error)")
        }
        
        isLoading = false
        return nil
    }
    
    func createSession(name: String, description: String, mode: GpsSessionType) async {
        isLoading = true
        
        if name == "" {
            isLoading = false
            return
        } else if description == "" {
            isLoading = false
            return
        }
        
        let urlString = "\(baseURL)\(gpsSessionsEndpoint)"

        let minSpeed = mode == .walking ? 360.0 : 360.0
        let maxSpeed = mode == .walking ? 720.0 : 600.0
        let data = [
            "name": name,
            "description": description,
            "gpsSessionTypeId": mode == .walking ? "00000000-0000-0000-0000-000000000003" : "00000000-0000-0000-0000-000000000001",
            "paceMin": minSpeed,
            "paceMax": maxSpeed,
        ] as [String: Any]
        
        guard let url = URL(string: urlString) else {
            print("unable to make string: \(urlString) to URL object")
            isLoading = false
            return
        }
        
        guard let encoded = try? JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            print("Failed to encode data: \(data)")
            isLoading = false
            return
        }
        
        guard let token = savedUser?.jwtToken else {
            print("Failed to receive token: \(savedUser)")
            isLoading = false
            return
        }
        
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: req, from: encoded)
            
            guard let res = response as? HTTPURLResponse else {
                print("Invalid response")
                isLoading = false
                return
            }
            
            if res.statusCode == 201 {
                print("session created successfully")
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    guard let userId = json["appUserId"] as? String,
                          let sessionId = json["id"] as? String else {
                        print("Error getting data from json: \(json)")
                        isLoading = false
                        return
                    }
                    
                    UserDefaults.standard.set(sessionId, forKey: "savedSessionId")
                    savedSessionId = sessionId
                    
                    if savedSessionId != nil {
                        isLoading = false
                        createSessionSuccess = true
                    }
                } else {
                    print("Error inserting session to db")
                    isLoading = false
                    return
                }
            } else {
                print("HTTP Status Code: \(res.statusCode)")
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                    // Handle the error using the responseString
                } else {
                    print("Failed to convert response data to string.")
                    // Handle the error appropriately
                }
                // Handle the error appropriately
            }
        } catch {
            print("Error: \(error)")
        }
        
        isLoading = false
    }
    
}
