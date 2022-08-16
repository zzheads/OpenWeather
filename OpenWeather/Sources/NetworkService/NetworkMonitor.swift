//
//  NetworkMonitor.swift
//  Stan2000
//
//  Created by Алексей Папин on 04.02.2022.
//  Copyright © 2022 Sportmaster. All rights reserved.
//

import Foundation
import Network

// MARK: - NetworkStatusListener
public protocol NetworkStatusListener: AnyObject {
	func handle(path: NWPath)
}

// MARK: - NetworkMonitor
public protocol INetworkMonitor: AnyObject {
	var currentPath: NWPath { get }
	
	func start()
	func cancel()
	func add(_ listener: NetworkStatusListener)
	func remove(_ listener: NetworkStatusListener)
}

// MARK: - NetworkMonitor
public final class NetworkMonitor {
	private let pathMonitorQueue = DispatchQueue(label: "com.Stan2000.NetworkManager.pathMonitorQueue", qos: .background)
	private lazy var pathMonitor: NWPathMonitor = {
		let monitor = NWPathMonitor()
		monitor.pathUpdateHandler = notify(_:)
		return monitor
	}()	
	private var listeners: [NetworkStatusListener] = []

	// MARK: - Initializing
	init() {
		start()
	}
	
	deinit {
		cancel()
	}
	
	// MARK: - Private methods
	private func notify(_ path: NWPath) {
		listeners.forEach { $0.handle(path: path) }
	}
}

// MARK: - NetworkMonitor
extension NetworkMonitor: INetworkMonitor {
	public var currentPath: NWPath { pathMonitor.currentPath }
	
	public func start() {
		pathMonitor.start(queue: pathMonitorQueue)
	}
	
	public func cancel() {
		pathMonitor.cancel()
	}
	
	public func add(_ listener: NetworkStatusListener) {
		guard !listeners.contains(where: { $0 === listener }) else { return }
		listeners.append(listener)
	}
	
	public func remove(_ listener: NetworkStatusListener) {
		guard let index = listeners.firstIndex(where: { $0 === listener }) else { return }
		listeners.remove(at: index)
	}
}
