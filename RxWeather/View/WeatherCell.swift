//
//  WeatherCell.swift
//  RxWeather
//
//  Created by Mark on 2/2/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
	@IBOutlet weak var lastUpdateTime: UILabel!
	@IBOutlet weak var temperature: UILabel!
	@IBOutlet weak var city: UILabel!
	
	static let identifier = "WeatherCell"
	
	var weather: Weather? {
		didSet {
			lastUpdateTime.text = weather!.lastUpdatedTime?.sunTime
			city.text = weather!.cityName
			if let temp = weather!.currentTemp {
				temperature.text = "\(temp)º"
			} else {
				temperature.text = "N/A"
			}
			
			if let icon = weather!.icon {
				print(icon)
				let backgroundView = UIImageView(image: UIImage(named: "\(icon)_background"))
				backgroundView.contentMode = .scaleAspectFill
				self.backgroundView = backgroundView
			} else {
				self.backgroundView = nil
			}
		}
	}
}
