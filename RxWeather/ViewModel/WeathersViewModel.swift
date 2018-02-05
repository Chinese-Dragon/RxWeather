//
//  WeathersViewModel.swift
//  RxWeather
//
//  Created by Mark on 2/2/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

typealias coord = CLLocationCoordinate2D

final class WeathersViewModel {
	var cityCoordinate: PublishSubject<coord> = PublishSubject()
	var weathers: Variable<[Weather]> = Variable([])
	var citiesCoordinates: [coord] = []
	
	private let apiService = WeatherAPIService.shareInstance
	private let dispose = DisposeBag()
	private let refreshInterval = 60.0
	
	init() {
		// when init we tried to go fetch a list of weather with coordinate data
		setupBinding()
	}
	
	func setupBinding() {
		updates()
			.bind(to: cityCoordinate)
			.disposed(by: dispose)
		
		let currentWeatherStream = cityCoordinate
			.asObservable()
			.flatMap { [weak self] coord -> Observable<Weather> in
				// transform coordinates into weathers
				return (self?.apiService.fetchWeather(cityLocation: coord))!
			}
		
		let forcastesStream = cityCoordinate
			.asObservable()
			.flatMap { [weak self] coord -> Observable<[Weather.Forecast]> in
				return (self?.apiService.fetchForecasts(cityLocation: coord))!
		}
		
		Observable
			.zip(currentWeatherStream, forcastesStream) { ($0, $1) }
			.subscribe{ [weak self] (next) in
				if let (weather, forecasts) = next.element {
					weather.forecasts = forecasts
					if let index = self?.weathers.value.index(where: { (wt) -> Bool in
						wt.cityId == weather.cityId
					}) {
						// update weathers array if the previous city exist
						self?.weathers.value[index] = weather
					} else {
						// otherwise, we append the new weather
						self?.weathers.value.append(weather)
					}
					
				}
			}
			.disposed(by: dispose)
	}
	
	func updates() -> Observable<coord> {
		// every 2 min this observable will issue current coordinates number of emits
		return Observable.create { [weak self ] observer in
			guard let strongSelf = self else { return Disposables.create() }
			let timer = Timer.scheduledTimer(withTimeInterval: strongSelf.refreshInterval, repeats: true) { timer in
				DispatchQueue.global(qos: .background).async {
					for coordiante in strongSelf.citiesCoordinates {
						observer.onNext(coordiante)
					}
				}
			}
			timer.fire()
			return Disposables.create {
				timer.invalidate()
			}
		}
	}
}
