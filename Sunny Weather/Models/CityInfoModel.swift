//
//  CityInfoModel.swift
//  Sunny Weather
//
//  Created by XE on 25.03.2024.
//

import Foundation

struct CityInfoModel: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let state: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
        case country
        case state
    }
}

