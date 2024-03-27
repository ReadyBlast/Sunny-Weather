//
//  Coordinator.swift
//  Sunny Weather
//
//  Created by XE on 26.03.2024.
//

import CoreLocation
import Foundation
import UIKit

final class Coordinator {
    func start(in window: UIWindow, networkService: INetworkService) {
        let service = networkService
        let viewModel = MainViewModel(networkService: service)
        let controller = MainViewController(viewModel: viewModel)
        
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
