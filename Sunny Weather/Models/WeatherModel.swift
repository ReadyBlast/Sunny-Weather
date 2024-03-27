//
//  Weather.swift
//  Sunny Weather
//
//  Created by XE on 25.03.2024.
//

import Foundation

struct WeatherModel: Codable {
    let coordinates: Coordinates
    let weatherInfo: [WeatherInfo]
    let base: String
    let mainTemperatureData: MainTemperatureData
    let visibility: Int
    let timeOfDataUTC: Int
    let timezone: Int
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weatherInfo = "weather"
        case base
        case mainTemperatureData = "main"
        case visibility
        case timeOfDataUTC = "dt"
        case timezone
        case id
        case name
    }
}

struct Coordinates: Codable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct WeatherInfo: Codable {
    let weatherId: Int
    let mainWeatherParameter: String
    let weatherDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case weatherId = "id"
        case mainWeatherParameter = "main"
        case weatherDescription = "description"
        case icon
    }
}

struct MainTemperatureData: Codable {
    let temperature: Double
    let feelsLike: Double
    let minimalTemperature: Double
    let maximumTemperature: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minimalTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure
        case humidity
    }
}

struct Wind: Codable {
    let speed: Double
    let directionDegrees: Int
    let gust: Double
    
    enum CodingKeys: String, CodingKey {
        case speed
        case directionDegrees = "deg"
        case gust
    }
}

struct Clouds: Codable {
    let percentageOfCloudiness: Int
    
    enum CodingKeys: String, CodingKey {
        case percentageOfCloudiness = "all"
    }
}

struct Percipitation: Codable {
    let volumeForLastHour: OptionallyDecodable<Double>
    let volumeForLastThreeHours: OptionallyDecodable<Double>
    
    enum CodingKeys: String, CodingKey {
        case volumeForLastHour = "1h"
        case volumeForLastThreeHours = "3h"
    }
}

struct SystemData: Codable {
    let type: OptionallyDecodable<Int>
    let id: OptionallyDecodable<Int>
    let message: OptionallyDecodable<String>
    let country: String
    let sunrise: Int
    let sunset: Int
}


//struct WeatherModel: Codable {
//    let coord: Coord
//    let weather: [Weather]
//    let base: String
//    let main: Main
//    let visibility: Int
//    let wind: Wind
//    let rain: Rain
//    let clouds: Clouds
//    let dt: Int
//    let sys: Sys
//    let timezone, id: Int
//    let name: String
//    let cod: Int
//}
//
//// MARK: - Clouds
//struct Clouds: Codable {
//    let all: Int
//}
//
//// MARK: - Coord
//struct Coord: Codable {
//    let lon, lat: Double
//}
//
//// MARK: - Main
//struct Main: Codable {
//    let temp, feelsLike, tempMin, tempMax: Double
//    let pressure, humidity, seaLevel, grndLevel: Int
//
//    enum CodingKeys: String, CodingKey {
//        case temp
//        case feelsLike = "feels_like"
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//        case pressure, humidity
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
//    }
//}
//
//// MARK: - Rain
//struct Rain: Codable {
//    let the1H: Double
//
//    enum CodingKeys: String, CodingKey {
//        case the1H = "1h"
//    }
//}
//
//// MARK: - Sys
//struct Sys: Codable {
//    let type, id: Int
//    let country: String
//    let sunrise, sunset: Int
//}
//
//// MARK: - Weather
//struct Weather: Codable {
//    let id: Int
//    let main, description, icon: String
//}
//
//// MARK: - Wind
//struct Wind: Codable {
//    let speed: Double
//    let deg: Int
//    let gust: Double
//}
