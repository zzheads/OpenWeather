//
//  APIKey.swift
//  OpenWeather
//
//  Created by Алексей Папин on 16.08.2022.
//  Copyright © 2022 Sportmaster. All rights reserved.
//

import Foundation

// MARK: - Constants
public enum Constants {
	/// Ключ API OpenWeather
	static let apiKey = "ecd8c69b22740df63e5a783529ce9318"
	/// URL OpenWeather
	static let apiUrl = "https://api.openweathermap.org/data/2.5/"

	/// Получение URL иконки OpenWeather
	static func iconUrl(path: String?) -> URL? {
		guard let path = path else { return nil }
		return URL(string: "https://openweathermap.org/img/w/\(path).png")
	}
}
