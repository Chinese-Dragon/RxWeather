//
//  ForecastCell.swift
//  RxWeather
//
//  Created by Mark on 2/1/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
	@IBOutlet weak var forecastImage: UIImageView!
	@IBOutlet weak var maxTemp: UILabel!
	@IBOutlet weak var minTemp: UILabel!
	@IBOutlet weak var dayInWeek: UILabel!
	@IBOutlet weak var forecastTime: UILabel!
	
	static let identifier = "ForecastCell"
	
	var forecast: Weather.Forecast? {
		didSet {
			forecastImage.image = UIImage(named: forecast!.icon)
			maxTemp.text = forecast!.maxTemp.description
			minTemp.text = forecast!.minTemp.description
			dayInWeek.text = forecast!.date.dayInWeek
			forecastTime.text = forecast!.date.sunTime
		}
	}
}
