//
//  RequestBuilder.swift
//  Stan2000
//
//  Created by Алексей Папин on 17.08.2021.
//

import Alamofire
import UIKit

public protocol IRequestBuilder: AnyObject {
	var restURL: String? { get }
	var headers: HTTPHeaders { get set }
	
	func addAuthHeader(jwtAccess: String)
	func build(request: NetworkRequest) throws -> URLRequest
}

// MARK: - RequestBuilder
final class RequestBuilder {
	enum Error: Swift.Error { case buildURL(String) }

	public let restURL: String?
	public var headers: HTTPHeaders

	init(restURL: String?, headers: HTTPHeaders?) {
		self.restURL = restURL
		self.headers = headers ?? HTTPHeaders()
	}
}

extension RequestBuilder: IRequestBuilder {
	public func addAuthHeader(jwtAccess: String) {
		headers.add(HTTPHeader.authorization(bearerToken: jwtAccess))
	}
	
	public func build(request: NetworkRequest) throws -> URLRequest {
		let fullPath = [restURL, request.endpoint.rawValue].compactMap { $0 }.joined(separator: "/")
		guard let url = URL(string: fullPath) else {
			throw Error.buildURL(fullPath)
		}

		var urlRequest = URLRequest(url: url)
		urlRequest.method = request.method

		urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: request.httpBody)
		urlRequest = try URLEncoding.queryString.encode(urlRequest, with: request.queryString)

		request.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.name) }
		headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.name) }
		return urlRequest
	}
}
