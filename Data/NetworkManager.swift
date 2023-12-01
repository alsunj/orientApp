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
    private let registerEndpoint = "/register"
    private let loginEndpoint = "/login"
    private let gpsSessionsEndpoint = "/GpsSessions"
    private let gpsLocations = "/GpsLocations"
    private let gpsLocationTypes = "/GpsLocationTypes"
    
    // Authentication
    func registerUser(user: User, completion: @escaping (Result<String, Error>) -> Void) {
           let registerURL = URL(string: "\(baseURL)\(registerEndpoint)")!
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
    func loginUser(credentials: LoginUser, completion: @escaping (Result<String, Error>) -> Void) {            let loginURL = URL(string: "\(baseURL)\(loginEndpoint)")!
        let requestBody: [String: Any] = [
                    "email": credentials.email,
                    "password": credentials.password
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
        let startSessionURL = URL(string: "\(baseURL)\(gpsSessionsEndpoint)")!
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
    func getLocationTypes(requestBody: [String: Any]? = nil, completion: @escaping (Result<[LocationType], Error>) -> Void) {
        let locationTypesURL = URL(string: "\(baseURL)/GpsLocationTypes")!

        performRequest(url: locationTypesURL, method: "GET", body: requestBody ?? [:]) { (result: Result<String, Error>) in
            switch result {
            case .success(let responseString):
                if let responseData = responseString.data(using: .utf8) {
                    do {
                        let decodedLocationTypes = try JSONDecoder().decode([LocationType].self, from: responseData)
                        completion(.success(decodedLocationTypes))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "Invalid response", code: 0, userInfo: nil)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }




    func postLocationUpdate(location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        let postLocationURL = URL(string: "\(baseURL)/GpsLocations")!

        let requestBody: [String: Any] = [
            "recordedAt": location.recordedAt,
            "latitude": location.latitude,
            "longitude": location.longitude,
            "accuracy": location.accuracy,
            "altitude": location.altitude,
            "verticalAccuracy": location.verticalAccuracy,
            "gpsSessionId": location.gpsSessionId,
            "gpsLocationTypeId": location.gpsLocationTypeId
        ]

        performRequest(url: postLocationURL, method: "POST", body: requestBody) { (result: Result<String, Error>) in
            switch result {
            case .success:
                completion(.success(()))  // Successfully posted, no specific value to return
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}




