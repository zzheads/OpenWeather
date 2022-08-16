//
//  ViewModel.swift
//  Finance
//
//  Created by Алексей Папин on 27.07.2021.
//

import Foundation
import UIKit

// MARK: - ViewModel
public protocol ViewModel: AnyObject {
	var pushController: ((UIViewController, Bool) -> Void)? { get set }
	var presentController: ((UIViewController, Bool, (() -> Void)?) -> Void)? { get set }

	func setup()
	func viewDidLoad()
	func didBindUI()
	func viewWillAppear(_ animated: Bool)
	func viewDidAppear(_ animated: Bool)
	func viewWillDisappear(_ animated: Bool)
	func viewDidDisappear(_ animated: Bool)
}

// MARK: - BaseViewModel
public class BaseViewModel: NSObject, ViewModel {
	public var pushController: ((UIViewController, Bool) -> Void)?
	public var presentController: ((UIViewController, Bool, (() -> Void)?) -> Void)?

	public func setup() {}
	public func viewDidLoad() {}
	public func didBindUI() {}
	public func viewWillAppear(_ animated: Bool) {}
	public func viewDidAppear(_ animated: Bool) {}
	public func viewWillDisappear(_ animated: Bool) {}
	public func viewDidDisappear(_ animated: Bool) {}
}
