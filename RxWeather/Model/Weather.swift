//
//  Weather.swift
//  RxWeather
//
//  Created by Mark on 1/31/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import CoreLocation

class Weather {
	enum WeatherItem {
		case humidity(Int)
		case windSpeed(Float)
		case pressure(Int)
		case sunrise(Date)
		case sunset(Date)
		
		var dataDescription: (String, String) {
			switch self {
			case .humidity(let humidity):
				return ("Humidity", "\(humidity)%")
			case .pressure(let pressure):
				return ("Pressure", "\(pressure)mb")
			case .windSpeed(let speed):
				return Weather.currentUnit
					== .celsius
					? ("Wind", "\(speed)KPH")
					: ("Wind", "\(speed)MPH")
			case .sunrise(let riseTime):
				return ("Sunrise" ,riseTime.sunTime)
				
			case .sunset(let setTime):
				return ("Sunset", setTime.sunTime)
			}
		}
	}
	
	enum Unit {
		case celsius
		case fahrenheit
	}
	
	struct Forecast {
		var icon: String
		var minTemp: Int
		var maxTemp: Int
		var date: Date
		
		init(iconStr: String, min: Int, max: Int, dt: Date) {
			icon = iconStr
			minTemp = min
			maxTemp = max
			date = dt
		}
		
		init?(json: JSON) {
			icon = json["weather"][0]["icon"].string!
			minTemp = json["main"]["temp_min"].int!
			maxTemp = json["main"]["temp_max"].int!
			date = Date(timeIntervalSince1970: json["dt"].double!)
		}
	}
	
	// Default unit is Celsius
	static var currentUnit = Unit.celsius
	
	var cityId: Int?
	
	var cityName: String?
	var currentTemp: Int?
	var lastUpdatedTime: String?
	var icon: String?

	var condition: String?
	var detailItems: [WeatherItem] = []
	var forecasts: [Forecast] = []
	
	init(id: Int? = nil, name: String? = nil, temp: Int? = nil,
		 time: String? = nil, weatherIcon: String? = nil,
		 weatherCondition: String? = nil, details: [WeatherItem]? = nil,
		 weatherForecasts: [Forecast]? = nil) {
		cityId = id
		cityName = name
		currentTemp = temp
		lastUpdatedTime = time
		icon = weatherIcon
		condition = weatherCondition

		if let items = details {
			detailItems = items
		}

		if let forecastsUnwrapped = weatherForecasts {
			forecasts = forecastsUnwrapped
		}
	}
	
	init?(json: JSON) {
		let countryCode = json["sys"]["country"].string!
		cityId = json["id"].int!
		cityName = "\(json["name"].string!), \(countryCode)"
		currentTemp = json["main"]["temp"].int!
		condition = json["weather"][0]["description"].string!
		icon = json["weather"][0]["icon"].string!
		
		// get weather local time from geo coordinates
		let lat = json["coord"]["lat"].double!
		let lon = json["coord"]["lon"].double!
		let location = CLLocation(latitude: lat, longitude: lon)
		lastUpdatedTime = Date.getLocalTime(withLocation: location)
		
		// construct weather items
		let humidity = WeatherItem.humidity(json["main"]["humidity"].int!)
		let pressure = WeatherItem.pressure(json["main"]["pressure"].int!)
		let windSpeed = WeatherItem.windSpeed(json["wind"]["speed"].float!)
		let sunRise = WeatherItem.sunset(Date(timeIntervalSince1970: json["sys"]["sunrise"].double!))
		let sunSet = WeatherItem.sunset(Date(timeIntervalSince1970: json["sys"]["sunset"].double!))
		
		detailItems = [humidity, pressure, windSpeed, sunRise, sunSet]
	}
}



