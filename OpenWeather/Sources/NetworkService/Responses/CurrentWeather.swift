//
//  CurrentWeather.swift
//  OpenWeather
//
//  Created by Алексей Папин on 16.08.2022.
//  Copyright © 2022 Sportmaster. All rights reserved.
//

import Foundation

//{
//	"coord": {
//		"lon": -122.08,
//		"lat": 37.39
//	},
//	"weather": [
//		{
//	"id": 800,
//	"main": "Clear",
//	"description": "clear sky",
//	"icon": "01d"
//		}
//	],
//	"base": "stations",
//	"main": {
//		"temp": 282.55,
//		"feels_like": 281.86,
//		"temp_min": 280.37,
//		"temp_max": 284.26,
//		"pressure": 1023,
//		"humidity": 100
//	},
//	"visibility": 10000,
//	"wind": {
//		"speed": 1.5,
//		"deg": 350
//	},
//	"clouds": {
//		"all": 1
//	},
//	"dt": 1560350645,
//	"sys": {
//		"type": 1,
//		"id": 5122,
//		"message": 0.0139,
//		"country": "US",
//		"sunrise": 1560343627,
//		"sunset": 1560396563
//	},
//	"timezone": -25200,
//	"id": 420006353,
//	"name": "Mountain View",
//	"cod": 200
//}

public struct CurrentWeather: Codable {
	struct Coord: Codable {
		let lon: Double
		let lat: Double
	}

	struct Weather: Codable {
		let id: Int
		let main: String
		let description: String
		let icon: String
	}

	struct Main: Codable {
		let temp: Double
		let feels_like: Double
		let temp_min: Double
		let temp_max: Double
		let pressure: Double
		let humidity: Double

		var description: String {
			[
				"feels like: \(feels_like)",
				"temp min: \(temp_min)",
				"temp max: \(temp_max)",
				"pressure: \(pressure) hPa",
				"humidity: \(humidity) %"
			].joined(separator: "\n")
		}
	}

	struct Wind: Codable {
		let speed: Double
		let deg: Double
	}

	struct Clouds: Codable {
		let all: Int
	}

	let id: Int
	let timezone: Int
	let name: String
	let cod: Int
	let base: String
	let dt: Double
	let visibility: Double
	let coord: Coord
	let weather: [Weather]
	let main: Main
	let wind: Wind
	let clouds: Clouds

	var description: String {
		[
			weather.first?.main,
			main.description
		]
			.compactMap { $0 }
			.joined(separator: "\n")
	}
}
