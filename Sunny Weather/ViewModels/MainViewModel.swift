//
//  MainViewModel.swift
//  Sunny Weather
//
//  Created by XE on 23.03.2024.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay

protocol IMainViewModel {
    var weatherModelRelay: PublishRelay<WeatherModel> { get }
    var errorWithFetchingData: PublishRelay<String> { get }
    func getCityInfo(with cityName: String?)
    func getWeatherInfo(latitude: Double, longitude: Double)
}

final class MainViewModel: IMainViewModel {
    
    private let networkService: INetworkService
    private var weatherInfo: WeatherModel?
    var weatherModelRelay = PublishRelay<WeatherModel>()
    var errorWithFetchingData = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    
    public init(networkService: INetworkService) {
        self.networkService = networkService
        
        _ = networkService.cityInfoRelay.subscribe { [weak self] cityInfo  in
            if let correctCityInfo = cityInfo.element {
                if let correctCityInfoElement = correctCityInfo {
                    self?.getWeatherInfo(latitude: correctCityInfoElement.latitude, longitude: correctCityInfoElement.longitude)
                } else {
                    self?.errorWithFetchingData.accept("Error")
                }
            }
        }.disposed(by: disposeBag)
        
        _ = networkService.weatherInfoRelay.subscribe { [weak self] weatherData in
            if let correctWeatherData = weatherData {
                self?.weatherModelRelay.accept(correctWeatherData)
            }  else {
                self?.errorWithFetchingData.accept("Error")
            }
        }.disposed(by: disposeBag)
        
    }
    
    func getCityInfo(with cityName: String?) {
        networkService.getCityInfo(for: cityName)

    }
    
    func getWeatherInfo(latitude: Double, longitude: Double) {
        networkService.getWeatherInfo(longitude: longitude, latitude: latitude)
    }
}
