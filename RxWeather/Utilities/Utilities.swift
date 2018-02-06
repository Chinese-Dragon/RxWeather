//
//  Utilities.swift
//  RxWeather
//
//  Created by Mark on 2/1/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import APTimeZones

extension Date {
	var sunTime: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		formatter.amSymbol = "AM"
		formatter.pmSymbol = "PM"
		return formatter.string(from: self)
	}
	
	var dayInWeek: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "E"
		return formatter.string(from: self)
	}
	
	static func getLocalTime(withLocation location: CLLocation) -> String {
		let currentTime = Date()
		let formatter = DateFormatter()
		let timeZone = APTimeZones.sharedInstance().timeZone(with: location)
		formatter.timeZone = timeZone
		formatter.dateFormat = "h:mm a"
		formatter.amSymbol = "AM"
		formatter.pmSymbol = "PM"
		return formatter.string(from: currentTime)
	}
}

extension UIColor {
	static let cellBackgroundColor = UIColor(displayP3Red: 85.0/255.0, green: 85.0/255.0, blue: 95.0/255.0, alpha: 1)
	static let primaryTextColor = UIColor(displayP3Red: 166.0/255.0, green: 166.0/255.0, blue: 166.0/255.0, alpha: 1)
	static let secondaryTextColor = UIColor(displayP3Red: 125.0/255.0, green: 125.0/255.0, blue: 125.0/255.0, alpha: 1)
	static let primaryTextHighlight = UIColor(displayP3Red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1)
	static let cellSeperator = UIColor(displayP3Red: 111.0/255.0, green: 111.0/255.0, blue: 117.0/255.0, alpha: 1)
	static let searchBarTint = UIColor(displayP3Red: 56.0/255.0, green: 57.0/255.0, blue: 66.0/255.0, alpha: 1)
	static let navBarTint = UIColor(displayP3Red: 77.0/255.0, green: 77.0/255.0, blue: 84.0/255.0, alpha: 1)
}
