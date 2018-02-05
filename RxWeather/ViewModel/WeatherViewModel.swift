//
//  WeatherViewModel.swift
//  RxWeather
//
//  Created by Mark on 1/31/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import RxSwift

final class WeatherViewModel {
	let weather: Variable<Weather> = Variable(Weather())
	let dispose = DisposeBag()
	
	var cityName: Variable<String> = Variable("")
	var currentTemp: Variable<Int> = Variable(0)
	var icon: Variable<String> = Variable("")
	var condition: Variable<String> = Variable("")
	var detailItems: Variable<[Weather.WeatherItem]> = Variable([])
	var foreacasts: Variable<[Weather.Forecast]> = Variable([])
	var lastUpdatedTime: Variable<Date> = Variable(Date())
	
	init() {
		weather
			.asObservable()
			.subscribe { [weak self] (next) in
				guard let updatedWeather = next.element else { return }
				
				if let cityName = updatedWeather.cityName {
					self?.cityName.value = cityName
				}
				
				if let currentTemp = updatedWeather.currentTemp {
					self?.currentTemp.value = currentTemp
				}
				
				if let icon = updatedWeather.icon {
					self?.icon.value = icon
				}
				
				if let condition = updatedWeather.condition {
					self?.condition.value = condition
				}
				
				if let lastUpdatedTime = updatedWeather.lastUpdatedTime {
					self?.lastUpdatedTime.value = lastUpdatedTime
				}
				
				self?.detailItems.value = updatedWeather.detailItems
				self?.foreacasts.value = updatedWeather.forecasts
			}
			.disposed(by: dispose)
	}
}

