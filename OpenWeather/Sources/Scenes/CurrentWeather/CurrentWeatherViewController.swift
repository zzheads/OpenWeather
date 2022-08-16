//
//  CurrentWeatherViewController.swift
//  OpenWeather
//
//  Created by Алексей Папин on 16.08.2022.
//  Copyright © 2022 Sportmaster. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation

public final class CurrentWeatherViewController: BaseViewController<CurrentWeatherViewModel> {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var refreshButton: UIButton!


	public override func viewDidLoad() {
		super.viewDidLoad()
		refreshButton.addTarget(self, action: #selector(didPressed(_:)), for: .touchUpInside)
		updateView(with: CurrentWeatherViewModel.WeatherViewModel())
	}

	public override func bindUI() {
		super.bindUI()
		viewModel.updateView = { [weak self] viewModel in
			self?.updateView(with: viewModel)
		}
	}

	private func updateView(with viewModel: CurrentWeatherViewModel.WeatherViewModel) {
		nameLabel.text = viewModel.name
		tempLabel.text = viewModel.temp
		descriptionLabel.text = viewModel.description
		imageView.kf.setImage(
			with: viewModel.imageUrl,
			placeholder: nil,
			options: nil,
			progressBlock: nil
		) { [weak self] result in
			switch result {
			case let .success(imageResult):
				self?.imageView.image = imageResult.image
			case .failure:
				self?.imageView.image = nil
			}
		}
	}

	@objc private func didPressed(_ sender: UIButton) {
		viewModel.updateWeatherForCurrentLocation()
	}
}
