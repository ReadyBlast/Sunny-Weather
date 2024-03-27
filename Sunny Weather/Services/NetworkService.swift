//
//  NetworkServices.swift
//  Sunny Weather
//
//  Created by XE on 23.03.2024.
//

import CoreLocation
import Foundation
import RxRelay
import UIKit

private extension String {
     static let cityInfoURL = "https://api.openweathermap.org/geo/1.0/direct"
     static let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    
    static let apiKeyValue = "6f12f43f81dcd59e47dfd4ec1bdc576c"
    
    static let apiKeyName = "appid"
    static let unitsNameKey = "units"
    static let unitsValue = "metric"
    static let longitudeNameKey = "lon"
    static let latitudeNameKey = "lat"
    static let cityNameKey = "q"
}

enum HTTPType: String {
    case get = "GET"
    case post = "POST"
}

private extension NSError {
    static let networkError = NSError(domain: "Error with making URL Request", code: 0)
}

protocol INetworkService {
    var cityInfoRelay: PublishRelay<CityInfoModel?> { get }
    var weatherInfoRelay: PublishRelay<WeatherModel?> { get }
    func getCityInfo(for city: String?)
    func getWeatherInfo(longitude: Double, latitude: Double)
}

final class NetworkService: INetworkService {
    
    let cityInfoRelay = PublishRelay<CityInfoModel?>()
    let weatherInfoRelay = PublishRelay<WeatherModel?>()
    
    private var cityInfo: CityInfoModel?
    private var weatherInfo: WeatherModel?
    
    func getCityInfo(for city: String?) {
        try? sendRequest(city: city) { [weak self] data in
            guard let self else {return}
            
            parseCityInfo(from: data)
        }
    }
    
    private func parseCityInfo(from data: Data){
        let array = try? JSONDecoder().decode([CityInfoModel].self, from: data)
        
        cityInfoRelay.accept(array?.first)
    }
    
    private func sendRequest(city: String?,
                             completion: @escaping (Data) -> Void
    ) throws {
        var urlComponents = URLComponents(string: .cityInfoURL)
        let city = URLQueryItem(name: .cityNameKey, value: city)
        let apiKey = URLQueryItem(name: .apiKeyName, value: .apiKeyValue)
        urlComponents?.queryItems = [city, apiKey]
        guard let url = urlComponents?.url else {
            throw NSError.networkError
        }
        
        let request = URLRequest(url: url)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let data else {
                return
            }
            completion(data)
        }
        task.resume()
    }
    
    func getWeatherInfo(longitude: Double, latitude: Double) {
        try? sendRequest(longitude: longitude, latitude: latitude) { [weak self] data in
            guard let self else { return }
            
            self.parseWeatherInfo(from: data)
        }
    }
    
    private func sendRequest(longitude: Double,
                                           latitude: Double,
                             completion: @escaping (Data) -> Void
    ) throws {
        var urlComponents = URLComponents(string: .weatherURL)
        let lat = URLQueryItem(name: .latitudeNameKey, value: "\(latitude)")
        let lon = URLQueryItem(name: .longitudeNameKey, value: "\(longitude)")
        let appKey = URLQueryItem(name: .apiKeyName, value: .apiKeyValue)
        let units = URLQueryItem(name: .unitsNameKey, value: .unitsValue)
        urlComponents?.queryItems = [lon, lat, appKey, units]
        guard let url = urlComponents?.url else {
            throw NSError.networkError
        }
        let request = URLRequest(url: url)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let data else {
                return
            }
            completion(data)
        }
        task.resume()
    }
    
    private func parseWeatherInfo(from data: Data) {
        let weather = try? JSONDecoder().decode(WeatherModel.self, from: data)
        weatherInfoRelay.accept(weather)
    }
}
