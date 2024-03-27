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
