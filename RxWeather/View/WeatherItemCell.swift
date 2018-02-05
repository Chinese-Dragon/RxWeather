//
//  WeatherItemCellCollectionViewCell.swift
//  RxWeather
//
//  Created by Mark on 2/1/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit

class WeatherItemCell: UICollectionViewCell {
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var data: UILabel!
	
	static let identifier = "WeatherItemCell"
	
	var item: Weather.WeatherItem? {
		didSet {
			let (itemName, itemData) = item!.dataDescription
			typeLabel.text = itemName
			data.text = itemData
		}
	}
}

