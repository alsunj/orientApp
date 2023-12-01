//
//  NetworkManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 30.11.2023.
//

import Foundation
import MapKit


class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://sportmap.akaver.com/api/v1.0"
    private let registerEndpoint = "/account/register"
    private let loginEndpoint = "/account/login"
    private let gpsSessionsEndpoint = "/GpsSessions"
    private let gpsLocations = "/gpsLocations"
    
    @Published var isLoading : Bool = false
    @Published var savedSessionId: String? = nil
    @Published var createSessionSuccess : Bool = false
    @Published var savedUser: User? = nil
    @Published var registeredUser: User? = nil
    
    
    public enum GpsSessionType { case walking, running}
    public enum LocationType { case location, checkPoint, wayPoint}
    
    func login(email: String, password: String) async -> User? {
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
                    let firstName = json["firstName"] as! String
                    let lastName = json["lastName"] as! String
                    let userEmail = email
                    let userPassword = password
                    
                    print("Token: \(token)")
                    
                    let user = User(
                        email: userEmail,
                        password: userPassword,
                        firstName: firstName,
                        lastName: lastName,
                        jwtToken: token
                    )
                    
                    isLoading = false
                    return user
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
    
    
    func register(firstName: String, lastName: String, email: String, password: String) async -> Bool {
        isLoading = true
        let urlString = "\(baseURL)\(registerEndpoint)"
        let data = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password,
        ]
        
        guard let url = URL(string: urlString) else {
            print("Unable to make string: \(urlString) to URL object")
            isLoading = false
            return false
        }
        guard let encoded = try? JSONEncoder().encode(data) else {
            print("Failed to encode data: \(data)")
            isLoading = false
            return false
        }
        
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: req, from: encoded)
            
            guard let res = response as? HTTPURLResponse else {
                print("Invalid response")
                isLoading = false
                return false
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
                    return true
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
        return false
    }

    
    func createSession(name: String, description: String, mode: GpsSessionType) async -> Bool {
        isLoading = true
        
        if name.isEmpty || description.isEmpty {
            isLoading = false
            return false
        }
        
        let urlString = "\(baseURL)\(gpsSessionsEndpoint)"
        let minSpeed = mode == .walking ? 360.0 : 360.0
        let maxSpeed = mode == .walking ? 720.0 : 600.0
        
        let data: [String: Any] = [
            "name": name,
            "description": description,
            "gpsSessionTypeId": mode == .walking ? "00000000-0000-0000-0000-000000000003" : "00000000-0000-0000-0000-000000000001",
            "paceMin": minSpeed,
            "paceMax": maxSpeed,
        ]
        
        guard let url = URL(string: urlString) else {
            print("Unable to create URL from string: \(urlString)")
            isLoading = false
            return false
        }
        
        guard let encoded = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
            print("Failed to encode data: \(data)")
            isLoading = false
            return false
        }
        
        guard let token = Manager.shared.currentUser?.jwtToken else {
            print("Failed to retrieve token: \(Manager.shared.currentUser?.jwtToken)")
            isLoading = false
            return false
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
                return false
            }
            
            if res.statusCode == 201 {
                print("Session created successfully")
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let sessionId = json["id"] as? String {
                    UserDefaults.standard.set(sessionId, forKey: "savedSessionId")
                    savedSessionId = sessionId
                    print("\(sessionId)")
                    isLoading = false
                    return true
                } else {
                    print("Error extracting session data from JSON")
                }
            } else {
                print("HTTP Status Code: \(res.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                }
            }
        } catch {
            print("Error: \(error)")
        }
        
        isLoading = false
        return false
    }
    func updateLocation(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        locationType: LocationType
    ) async {
        if savedSessionId == nil { return }
        
        let urlString = "\(baseURL)\(gpsLocations)"
        let locTypeId = locationType == .location ? "00000000-0000-0000-0000-000000000001" : locationType == .checkPoint ? "00000000-0000-0000-0000-000000000002" : "00000000-0000-0000-0000-000000000003"
        let data = [
            "gpsSessionId": savedSessionId!,
            "gpsLocationTypeId": locTypeId,
            "latitude": latitude,
            "longitude": longitude,
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
        
        guard let token = Manager.shared.currentUser?.jwtToken else {
            print("Failed to receive token: \(Manager.shared.currentUser)")
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
                print("location updated successfully")
                
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("json from location: \(json)")
                    
                    return
                } else {
                    print("Error inserting session to db")
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
        
        return
    }

}
