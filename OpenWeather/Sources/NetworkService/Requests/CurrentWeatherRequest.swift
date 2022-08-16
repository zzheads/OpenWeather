//
//  CurrentWeatherRequest.swift
//  OpenWeather
//
//  Created by Алексей Папин on 16.08.2022.
//  Copyright © 2022 Sportmaster. All rights reserved.
//

import Alamofire
import CoreLocation

public struct CurrentWeatherRequest: Codable {
	public enum Mode: String, Codable {
		case xml
		case html
	}

	public enum Units: String, Codable {
		case standart
		case metric
		case imperial

		var sign: String {
			switch self {
			case .metric: return "°C"
			case .imperial: return "°F"
			case .standart: return "°K"
			}
		}
	}

	public enum Language: String, Codable {
		case russian = "ru"
		case english = "en"
	}

	let lat: CLLocationDegrees
	let lon: CLLocationDegrees
	let appId: String
	var mode: Mode? = nil
	var units: Units = .metric
	var lang: Language = .russian
}

extension CurrentWeatherRequest: NetworkRequest {
	public var endpoint: NetworkEndpoint { .weather }
	public var method: HTTPMethod { .get }
	public var httpBody: Parameters? { nil }
}
