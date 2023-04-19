//
//  Constants.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import Foundation

class Path: NSObject {
    static var BaseUrl = "https://api.openweathermap.org"
    static var appId = "7e363c3e31e00d16a311154cf41fc05e"
    
}

class Serviceheader: NSObject {
    static let urlEncoded = ["Content-Type": "application/x-www-form-urlencoded"]
}

class alertContent : NSObject {
    
    static var title = " Weather Alert"
    static var checkSearch = "City Not Found"
    static var permissionTitle = "Location Permission Required"
    static var permissionMsg = "Please enable Permission in Settings"
}
