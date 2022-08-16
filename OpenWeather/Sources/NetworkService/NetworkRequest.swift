//
//  NetworkRequest.swift
//  Finance
//
//  Created by Алексей Папин on 27.07.2021.
//

import Alamofire

// MARK: - NetworkRequest
public protocol NetworkRequest: Codable {
	var endpoint: NetworkEndpoint { get }
	var method: HTTPMethod { get }
	var httpBody: Parameters? { get }
	var queryString: Parameters? { get }
	var headers: HTTPHeaders { get }

	var pathAndMethod: String { get }
}

extension NetworkRequest {
	public var pathAndMethod: String {
		[endpoint.rawValue, method.rawValue].joined(separator: "-")
	}

	public var httpBody: Parameters? {
		guard
			let jsonData = try? JSONEncoder().encode(self),
			let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as? Parameters
		else { return nil }
		return jsonDict
	}

	public var queryString: Parameters? {
		guard
			let jsonData = try? JSONEncoder().encode(self),
			let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as? Parameters
		else { return nil }
		return jsonDict
	}

	public var headers: HTTPHeaders { [:] }
}
