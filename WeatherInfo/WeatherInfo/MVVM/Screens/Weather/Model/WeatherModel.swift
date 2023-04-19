//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import Foundation

struct WeatherModel:Codable {
    var weather : [Weather]?
    var main : Main?
    var wind : Wind?
    var clouds: Clouds?
    var system : System?
    var base : String?
    var visibility : Int?
    var date : Int?
    var timeZone : Int?
    var id : Int?
    var name : String?
    var cod : Int?
    
    
    enum CodingKeys:String,CodingKey {
        case weather = "weather"
        case main = "main"
        case wind = "wind"
        case clouds = "clouds"
        case system = "sys"
        case base = "base"
        case visibility = "visibility"
        case date = "dt"
        case timeZone = "timezone"
        case  id = "id"
        case name = "name"
        case cod = "cod"
        
        
    }
  
}


struct Weather:Codable {
    var id : Int?
    var main :String?
    var description: String?
    var icon: String?
    
    enum CodingKeys:String,CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
    
}
// MARK: - Main

struct Main:Codable {
    var temperature : Double?
    var feelLike : Double?
    var temperatureMin: Double?
    var temperatureMax: Double?
    var pressure: Int?
    var humidity: Int?
    
    enum CodingKeys:String,CodingKey {
        case temperature = "temp"
        case feelLike = "feels_like"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
        
    }
}
struct Wind:Codable {
    var speed : Double?
    var degree : Int?
    
    enum CodingKeys:String,CodingKey {
        case speed = "speed"
        case degree = "deg"
    }
}

struct Clouds:Codable {
    var clouds : Int?
    
    enum CodingKeys:String,CodingKey {
        case clouds = "all"
    }
}
struct System:Codable {
    
    var type: Int?
    var id : Int?
    var country : String?
    var sunrise : Int?
    var sunset : Int?
    
    enum Codingkeys:String,CodingKey {
        case type = "type"
        case id = "id"
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }

}

