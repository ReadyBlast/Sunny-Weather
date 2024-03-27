//
//  MainViewController.swift
//  Sunny Weather
//
//  Created by XE on 23.03.2024.
//

import CoreLocation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

private enum Offsets {
    static let defaultOffset = 12
}

private enum FontSize {
    static let largeHeader: CGFloat = 24
    static let veryLargeHeader: CGFloat = 64
}

private extension String {

    static func changeTemperatureLabel(_ weatherInfoData: WeatherModel) -> String {
        return "\(weatherInfoData.mainTemperatureData.temperature)°C"
    }
    static func changeMaxTemperatureLabel(_ weatherInfoData: WeatherModel) -> String {
        return "Highest temperature is: \(weatherInfoData.mainTemperatureData.maximumTemperature)°C"
    }
    static func changeMinTemperatureLabel(_ weatherInfoData: WeatherModel) -> String {
        return "Lowest temperature is: \(weatherInfoData.mainTemperatureData.minimalTemperature)°C"
    }
    static func changeTemperatureFeelsLikeLabel(_ weatherInfoData: WeatherModel) -> String {
        return "Temperature feels like \(weatherInfoData.mainTemperatureData.feelsLike)°C"
    }
    static func changeHumidityLabel(_ weatherInfoData: WeatherModel) -> String {
        return "Humidity percentage is \(weatherInfoData.mainTemperatureData.humidity)%"
    }
    static func changeVisibilityLabel(_ weatherInfoData: WeatherModel) -> String {
        return "Visibility in meters: \(weatherInfoData.visibility)"
    }
}

class MainViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private var viewModel: IMainViewModel
    private let disposeBag = DisposeBag()
    
    private var weatherData: WeatherModel?

    init(viewModel: IMainViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .white
 
        return searchBar
    }()
    
    private var cityNameLabel: UILabel = {
       let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.largeHeader)
        
        return label
    }()
    
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        
         label.textColor = .white
         label.textAlignment = .center
         label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.veryLargeHeader)
         
         return label
     }()
    
    private let weatherTypeLabel: UILabel = {
        let label = UILabel()
         
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        
         return label
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()

         label.textColor = .white
         label.textAlignment = .center
         label.numberOfLines = 0
         
         return label
    }()
    
    private let minTemperatureLabel: UILabel = {
        let label = UILabel()

         label.textColor = .white
         label.textAlignment = .center
         label.numberOfLines = 0
         
         return label
    }()
    
    private let temperatureFeelsLikeLabel: UILabel = {
        let label = UILabel()

         label.textColor = .white
         label.textAlignment = .center
         label.numberOfLines = 0
         
         return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()

         label.textColor = .white
         label.textAlignment = .center
         label.numberOfLines = 0
         
         return label
    }()
    
    private let visibilityLabel: UILabel = {
        let label = UILabel()

         label.textColor = .white
         label.textAlignment = .center
         label.numberOfLines = 0
         
         return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue

        configureLocationManager()
    
        bind()
    
        addViews()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    private func bind() {
        _ = viewModel.weatherModelRelay.subscribe { [weak self] weatherInfoData in
            self?.weatherData = weatherInfoData.element
            DispatchQueue.main.async {
                self?.updateLabelTexts()
            }
        }.disposed(by: disposeBag)
        
        _ = viewModel.errorWithFetchingData.subscribe { [ weak self ] string in
            let alert = UIAlertController(title: nil, message: "Oops... Something goes wrong", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Try Again", style: .cancel)
            alert.addAction(alertAction)
            
            DispatchQueue.main.async {
                self?.present(alert, animated: true)
            }
        }.disposed(by: disposeBag)
        
        searchBar.rx
            .searchButtonClicked
            .withLatestFrom(searchBar.rx.text)
            .observe(on: MainScheduler.instance)
            .subscribe { [ weak self ] _ in
                self?.viewModel.getCityInfo(with: self?.searchBar.text)
                self?.searchBar.resignFirstResponder()
            }.disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked.subscribe { [ weak self ] event in
                self?.searchBar.text = nil
                self?.searchBar.resignFirstResponder()
                self?.locationManager.startUpdatingLocation()
         }.disposed(by: disposeBag)
    }
    
    private func addViews() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        
        let wrapper = UIView()
        
        view.addSubview(wrapper)
        
        let arrayOfLabels = [cityNameLabel, temperatureLabel, weatherTypeLabel, maxTemperatureLabel, minTemperatureLabel, temperatureFeelsLikeLabel, humidityLabel, visibilityLabel]
        
        for (index, labelView) in arrayOfLabels.enumerated() {
            
            wrapper.addSubview(labelView)
            
            if index == arrayOfLabels.startIndex {
                labelView.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.directionalHorizontalEdges.equalToSuperview()
                }
            } else if index == arrayOfLabels.endIndex - 1 {
                labelView.snp.makeConstraints { make in
                    make.top.equalTo(arrayOfLabels[arrayOfLabels.index(before: index)].snp.bottom).offset(Offsets.defaultOffset)
                    make.directionalHorizontalEdges.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            } else {
                labelView.snp.makeConstraints { make in
                    make.top.equalTo(arrayOfLabels[arrayOfLabels.index(before: index)].snp.bottom).offset(Offsets.defaultOffset)
                    make.directionalHorizontalEdges.equalToSuperview()
                }
            }
        }
        
        wrapper.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    private func updateLabelTexts() {
        guard let weatherData = weatherData else { return }
        
        cityNameLabel.text = weatherData.name
        temperatureLabel.text = .changeTemperatureLabel(weatherData)
        weatherTypeLabel.text = weatherData.weatherInfo.first?.mainWeatherParameter
        maxTemperatureLabel.text = .changeMaxTemperatureLabel(weatherData)
        minTemperatureLabel.text = .changeMinTemperatureLabel(weatherData)
        temperatureFeelsLikeLabel.text = .changeTemperatureFeelsLikeLabel(weatherData)
        humidityLabel.text = .changeHumidityLabel(weatherData)
        visibilityLabel.text = .changeVisibilityLabel(weatherData)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latitude = manager.location?.coordinate.latitude else { return }
        guard let longitude = manager.location?.coordinate.longitude else { return }
        
        viewModel.getWeatherInfo(latitude: Double(latitude), longitude: Double(longitude))
        locationManager.stopUpdatingLocation()
    }
}
