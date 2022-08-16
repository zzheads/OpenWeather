//
//  ViewController.swift
//  Finance
//
//  Created by Алексей Папин on 27.07.2021.
//

import UIKit

// MARK: - ViewController
public protocol ViewController: UIViewController {
	associatedtype ViewModelType: ViewModel
	var viewModel: ViewModelType { get }

	func setup()
	func bindUI()
}

// MARK: - BaseViewController
public class BaseViewController<ViewModelType: ViewModel>: UIViewController, ViewController {
	// MARK: - Public properties
	public let viewModel: ViewModelType

	// MARK: - Initializing
	public init(viewModel: ViewModelType) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		viewModel.setup()
		setup()
		bindUI()
		viewModel.didBindUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public methods
	public func setup() {}

	public func bindUI() {
		/// Default binding pushViewController
		/// self?.navigationController?.pushViewController(controller, animated: animated)
		viewModel.pushController = { [weak self] controller, animated in
			self?.navigationController?.pushViewController(controller, animated: animated)
		}

		/// Default binding presentViewController
		/// self?.present(controller, animated: animated, completion: completion)
		viewModel.presentController = { [weak self] controller, animated, completion in
			self?.present(controller, animated: animated, completion: completion)
		}
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.viewDidLoad()
	}

	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.viewWillAppear(animated)
	}

	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		viewModel.viewDidAppear(animated)
	}

	public override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		viewModel.viewWillDisappear(animated)
	}

	public override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		viewModel.viewDidDisappear(animated)
	}
}

extension BaseViewController where ViewModelType: BaseViewModel {
	func isSame(_ controller: UIViewController?) -> Bool {
		guard let controller = controller as? BaseViewController<ViewModelType> else { return false }
		return viewModel == controller.viewModel
	}
}
