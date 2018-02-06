//
//  ViewController.swift
//  RxWeather
//
//  Created by Mark on 1/31/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController {
	@IBOutlet weak var cityName: UILabel!
	@IBOutlet weak var temperature: UILabel!
	@IBOutlet weak var condition: UILabel!
	@IBOutlet weak var weatherItemCollectionView: UICollectionView!
	@IBOutlet weak var forecastCollectionView: UICollectionView!
	@IBOutlet weak var weatherIcon: UIImageView!
	@IBOutlet weak var lastUpdatedTime: UILabel!
	
	// has to be initialized by weatherTableviewController
	var viewModel = WeatherViewModel()
	let dispose = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViewBinding()
	}

	private func setupViewBinding() {
		viewModel.foreacasts
			.asObservable()
			.bind(to:
				forecastCollectionView.rx.items(
					cellIdentifier: ForecastCell.identifier,
					cellType: ForecastCell.self)) { (row, forecast, cell) in
						cell.forecast = forecast
		}.disposed(by: dispose)

		viewModel.detailItems
			.asObservable()
			.bind(to:
				weatherItemCollectionView.rx.items(
					cellIdentifier: WeatherItemCell.identifier,
					cellType: WeatherItemCell.self)) { (row, weatherItem, cell) in
						cell.item = weatherItem
		}.disposed(by: dispose)

		viewModel.cityName
			.asObservable()
			.bind(to: cityName.rx.text)
			.disposed(by: dispose)

		viewModel.currentTemp
			.asObservable()
			.map { $0.description }
			.bind(to: temperature.rx.text)
			.disposed(by: dispose)

		viewModel.condition
			.asObservable()
			.bind(to: condition.rx.text)
			.disposed(by: dispose)

		viewModel.icon
			.asObservable()
			.map { UIImage(named: "\($0)_background") }
			.bind(to: weatherIcon.rx.image)
			.disposed(by: dispose)
		
		viewModel.lastUpdatedTime
			.asObservable()
			.bind(to: lastUpdatedTime.rx.text)
			.disposed(by: dispose)
			
	}
	
	@IBAction func dismiss(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
}

