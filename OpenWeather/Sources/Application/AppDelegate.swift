//
//  AppDelegate.swift
//  OpenWeather
//
//  Created by Алексей Папин on 16.08.2022.
//  Copyright © 2022 Sportmaster. All rights reserved.
//	

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	// MARK: - Internal properties
	var window: UIWindow?

	// MARK: - Private properties
	private let requestBuilder: IRequestBuilder = RequestBuilder(
		restURL: Constants.apiUrl,
		headers: nil
	)

	private lazy var networkService: INetworkService = NetworkService(
		requestBuilder: requestBuilder,
		monitor: NetworkMonitor()
	)

	private lazy var rootController: CurrentWeatherViewController = {
		let model = CurrentWeatherViewModel(networkService: networkService)
		let controller = CurrentWeatherViewController(viewModel: model)
		return controller
	}()

	// MARK: - UIApplicationDelegate
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow()
		window?.rootViewController = rootController
		window?.makeKeyAndVisible()

		return true
	}
}

