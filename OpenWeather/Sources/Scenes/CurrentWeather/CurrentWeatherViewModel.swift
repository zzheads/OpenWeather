//
//  CurrentWeatherViewModel.swift
//  OpenWeather
//
//  Created by Алексей Папин on 16.08.2022.
//  Copyright © 2022 Sportmaster. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

// MARK: - CurrentWeatherViewModel
public class CurrentWeatherViewModel: BaseViewModel {
	struct WeatherViewModel {
		let name: String?
		let temp: String?
		let description: String?
		let imageUrl: URL?

		init() {
			self.name = nil
			self.temp = nil
			self.description = nil
			self.imageUrl = nil
		}

		init(weather: CurrentWeather, sign: String) {
			self.name = weather.name
			self.temp = "\(weather.main.temp) \(sign)"
			self.description = weather.description
			self.imageUrl = Constants.iconUrl(path: weather.weather.first?.icon)
		}

		init(error: Error) {
			self.name = "Ошибка:"
			self.temp = error.localizedDescription
			self.description = "\(error)"
			self.imageUrl = nil
		}
	}
	
	enum Error: Swift.Error {
		case afError(AFError)
		case locationRestricted
	}

	// MARK: - Private properties
	private let networkService: INetworkService
	private lazy var locationManager: CLLocationManager = {
		let manager = CLLocationManager()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		return manager
	}()

	private var currentLocation: CLLocation? {
		didSet {
			updateWeatherForCurrentLocation()
		}
	}

	// MARK: - Bindings
	var updateView: ((WeatherViewModel) -> Void)?

	// MARK: - Initializing
	init(networkService: INetworkService) {
		self.networkService = networkService
	}

	// MARK: - Lifecycle
	public override func didBindUI() {
		super.didBindUI()
		locationManager.requestWhenInUseAuthorization()
	}

	// MARK: - Public methods
	func updateWeatherForCurrentLocation() {
		guard let coordinate = currentLocation?.coordinate else { return }
		Task {
			let units: CurrentWeatherRequest.Units = .metric
			let request = CurrentWeatherRequest(
				lat: coordinate.latitude,
				lon: coordinate.longitude,
				appId: Constants.apiKey,
				units: units,
				lang: .russian
			)

			let result: Result<CurrentWeather, AFError> = await networkService.perform(request: request)
			let model: WeatherViewModel
			switch result {
			case let .success(weather):
				model = .init(weather: weather, sign: units.sign)
			case let .failure(error):
				model = .init(error: .afError(error))
			}

			DispatchQueue.main.async {
				self.updateView?(model)
			}
		}
	}
}

// MARK: - CLLocationManagerDelegate
extension CurrentWeatherViewModel: CLLocationManagerDelegate {
	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedAlways, .authorizedWhenInUse:
			locationManager.startUpdatingLocation()
		default:
			updateView?(WeatherViewModel(error: .locationRestricted))
		}
	}

	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		currentLocation = locations.first
	}
}
