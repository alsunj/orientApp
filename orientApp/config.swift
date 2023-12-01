//
//  config.swift
//  orientApp
//
//  Created by Alex Šunjajev on 11.01.2024.
//


import Foundation

struct Config {
    static let shared = Config()
    
    let backendUrl = "https://sportmap.akaver.com"
    let smtpHostname = "the host where your email is located on, f.e smtp.gmail.com"
    let smtpEmail = "email where we send the gpx data from"
    let smtpPassword = "for your email"
    let baseURL = "https://sportmap.akaver.com"
    let registerEndpoint = "/api/v1.0/account/register"
    let loginEndpoint = "/api/v1.0/account/login"
    let gpsSessionsEndpoint = "/api/v1.0/GpsSessions"
    let gpsLocations = "/api/v1.0/gpsLocations"

}

