//
//  WeathersTableViewController.swift
//  RxWeather
//
//  Created by Mark on 2/2/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit
import GooglePlaces
import RxSwift
import RxCocoa
import CoreLocation

class WeathersTableViewController: UIViewController {
	@IBOutlet weak var tableview: UITableView!
	
	let viewModel = WeathersViewModel()
	let dispose = DisposeBag()
	
	private let locationManager = CLLocationManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
		setupBinding()
		setupLocationService()
    }
	
	func setupLocationService() {
		locationManager.requestAlwaysAuthorization()
		locationManager.requestWhenInUseAuthorization()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestLocation()
	}
	
	private func setupUI() {
		tableview.rowHeight = UITableViewAutomaticDimension
		tableview.estimatedRowHeight = 80
	}
	
	private func setupBinding() {
		viewModel
			.weathers
			.asObservable()
			.observeOn(MainScheduler.instance)
			.bind(to: tableview.rx.items(
				cellIdentifier: WeatherCell.identifier,
				cellType: WeatherCell.self)) { (row, weather, cell) in
					
				cell.weather = weather
			}
			.disposed(by: dispose)
		
		tableview
			.rx
			.modelSelected(Weather.self)
			.subscribe { [weak self] (next) in
				if let selectedWeather = next.element {
					let targetVC = self?.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
					
					// send initialze singal
					targetVC.viewModel.weather.value = selectedWeather
					
					self?.present(targetVC, animated: true, completion: nil)
					
					self?.tableview.deselectRow(at: (self?.tableview.indexPathForSelectedRow!)!, animated: true)
				}
			}
			.disposed(by: dispose)
		
		viewModel
			.weathers
			.asObservable()
			.observeOn(MainScheduler.instance)
			.subscribe { [weak self] (next) in
				guard let newWeathers = next.element,
					let currentShowingVC = self?.presentedViewController as? WeatherViewController else { return }
					
				let newWeather = newWeathers.filter { $0.cityId == currentShowingVC.viewModel.weather.value.cityId }
				
				if let updatedWeather = newWeather.first {
					currentShowingVC.viewModel.weather.value = updatedWeather
				}
			}
			.disposed(by: dispose)
	}
	
	@IBAction func addCity(_ sender: UIButton) {
		let autocompleteController = GMSAutocompleteViewController()
		setupAutocompleteController(controller: autocompleteController)
		present(autocompleteController, animated: true, completion: nil)
	}
	
	private func setupAutocompleteController(controller: GMSAutocompleteViewController) {
		controller.delegate = self
		let filter = GMSAutocompleteFilter()
		filter.type = .city
		controller.autocompleteFilter = filter
//		controller.primaryTextColor = UIColor.primaryTextColor
//		controller.primaryTextHighlightColor = UIColor.primaryTextHighlight
//		controller.secondaryTextColor = UIColor.secondaryTextColor
//		controller.tableCellBackgroundColor = UIColor.cellBackgroundColor
//		controller.tableCellSeparatorColor = UIColor.cellSeperator
//		controller.navigationController?.navigationBar.barTintColor = UIColor.navBarTint
//		controller.navigationController?.navigationBar.tintColor = UIColor.navBarTint
//		if #available(iOS 11.0, *) {
//			controller.navigationItem.searchController?.searchBar.barTintColor = UIColor.searchBarTint
//		} else {
//			// Fallback on earlier versions
//		}
	}
}

extension WeathersTableViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let myLocation = locations.last {
			// send the first signal
			viewModel.cityCoordinate.onNext(myLocation.coordinate)
			viewModel.citiesCoordinates.append(myLocation.coordinate)
		}
	}
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
}

extension WeathersTableViewController: GMSAutocompleteViewControllerDelegate {
	// Handle the user's selection.
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		
		// emit the new city coordinate
		viewModel.cityCoordinate.onNext(place.coordinate)
		// save the new city coordiante for auto refreshing
		viewModel.citiesCoordinates.append(place.coordinate)
		
		dismiss(animated: true, completion: nil)
	}
	
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		// TODO: handle the error.
		print("Error: ", error.localizedDescription)
	}
	
	// User canceled the operation.
	func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	// Turn the network activity indicator on and off again.
	func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
}
