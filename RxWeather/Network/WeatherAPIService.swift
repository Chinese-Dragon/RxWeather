//
//  WeatherAPIService.swift
//  RxWeather
//
//  Created by Mark on 1/31/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import CoreLocation
import Alamofire
import SwiftyJSON

struct WeatherAPIService {
	static let shareInstance = WeatherAPIService()
	private init() {}
	
	
	func fetchWeather(cityLocation: CLLocationCoordinate2D) -> Observable<Weather> {
		let params: [String: Any] = [
			"lat": cityLocation.latitude,
			"lon": cityLocation.longitude,
			"units": "metric",
			"appid": Keys.OpenWeatherKey
		]
		
		return json(.get, APIs.CurrentWeatherUrl, parameters: params, encoding: URLEncoding.default)
				.flatMapLatest { json -> Observable<Weather> in
					guard let weather = Weather(json: JSON.init(json)) else {
						return Observable.empty()
					}
					return Observable.just(weather)
				}
	}
	
	func fetchForecasts(cityLocation: CLLocationCoordinate2D) -> Observable<[Weather.Forecast]> {
		let params: [String: Any] = [
			"lat": cityLocation.latitude,
			"lon": cityLocation.longitude,
			"units": "metric",
			"appid": Keys.OpenWeatherKey
		]
		
		return json(.get, APIs.ForecastWeatherUrl, parameters: params, encoding: URLEncoding.default)
			.map { JSON.init($0) }
			.flatMapLatest { json -> Observable<[Weather.Forecast]> in
				// flatMap can be used to remove nil values
				let forecasts = json["list"].arrayValue.flatMap {
					Weather.Forecast(json: $0)
				}
				
				return Observable.from(optional: forecasts)
			}
	}
}
