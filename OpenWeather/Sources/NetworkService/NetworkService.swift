//
//  NetworkService.swift
//  Finance
//
//  Created by Алексей Папин on 27.07.2021.
//

import Alamofire
import Network

// MARK: - NetworkError
public enum NetworkError: String, Error {
	case noInternet = "Отсутствует подключение к Интернет"
}

// MARK: - NetworkManager
public protocol INetworkService: AnyObject {
	var session: Session { get }
	var decoder: JSONDecoder { get }
	var requestBuilder: IRequestBuilder { get }
	var monitor: INetworkMonitor { get }

	func perform(request: NetworkRequest, handler: @escaping ((Result<Void, AFError>) -> Void))
	func perform(request: NetworkRequest, handler: @escaping ((Result<Data, AFError>) -> Void))
	func perform<T: Decodable>(request: NetworkRequest, handler: @escaping ((Result<T, AFError>) -> Void))
	
	func perform(request: NetworkRequest) async -> Result<Void, AFError>
	func perform(request: NetworkRequest) async -> Result<Data, AFError>
	func perform<T: Decodable>(request: NetworkRequest) async -> Result<T, AFError>
}

// MARK: - NetworkManager
extension INetworkService {
	public func perform(request: NetworkRequest, handler: @escaping ((Result<Void, AFError>) -> Void)) {
		guard monitor.currentPath.status == .satisfied else {
			handler(.failure(.sessionInvalidated(error: NetworkError.noInternet)))
			return
		}
		do {
			let urlRequest = try requestBuilder.build(request: request)
			session.request(urlRequest).validate().responseData { response in
				switch response.result {
				case .success:
					handler(.success(()))
				case let .failure(error):
					handler(.failure(error))
				}
			}
		} catch {
			handler(.failure(AFError.createURLRequestFailed(error: error)))
		}
	}

	public func perform(request: NetworkRequest, handler: @escaping ((Result<Data, AFError>) -> Void)) {
		guard monitor.currentPath.status == .satisfied else {
			handler(.failure(.sessionInvalidated(error: NetworkError.noInternet)))
			return
		}
		do {
			let urlRequest = try requestBuilder.build(request: request)
			session.request(urlRequest).validate().responseData { response in
				switch response.result {
				case let .success(data):
					handler(.success(data))
				case let .failure(afError):
					handler(.failure(afError))
				}
			}
		} catch {
			handler(.failure(AFError.createURLRequestFailed(error: error)))
		}
	}

	public func perform<T: Decodable>(request: NetworkRequest, handler: @escaping ((Result<T, AFError>) -> Void)) {
		perform(request: request) { [unowned self] (result: Result<Data, AFError>) in
			switch result {
			case let .success(data):
				do {
					let object = try self.decoder.decode(T.self, from: data)
					handler(.success(object))
				} catch {
					handler(.failure(AFError.responseSerializationFailed(reason: .decodingFailed(error: error))))
				}
			case let .failure(afError):
				handler(.failure(afError))
			}
		}
	}
	
	public func perform(request: NetworkRequest) async -> Result<Void, AFError> {
		await withCheckedContinuation { continuation in
			perform(request: request) { result in
				continuation.resume(returning: result)
			}
		}
	}
	
	public func perform(request: NetworkRequest) async -> Result<Data, AFError> {
		await withCheckedContinuation { continuation in
			perform(request: request) { result in
				continuation.resume(returning: result)
			}
		}
	}
	
	public func perform<T: Decodable>(request: NetworkRequest) async -> Result<T, AFError> {
		await withCheckedContinuation { continuation in
			perform(request: request) { result in
				continuation.resume(returning: result)
			}
		}
	}
}

// MARK: - NetworkManager
public class NetworkService: INetworkService {
	// MARK: - Public properties
	public let session: Session
	public let decoder: JSONDecoder
	public let requestBuilder: IRequestBuilder
	public let monitor: INetworkMonitor

	// MARK: - Initializing
	init(session: Session = .default, decoder: JSONDecoder = .init(), requestBuilder: IRequestBuilder, monitor: INetworkMonitor) {
		self.session = session
		self.decoder = decoder
		self.requestBuilder = requestBuilder
		self.monitor = monitor
	}
}
