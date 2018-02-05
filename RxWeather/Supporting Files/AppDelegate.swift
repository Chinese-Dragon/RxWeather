//
//  AppDelegate.swift
//  RxWeather
//
//  Created by Mark on 1/31/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		GMSPlacesClient.provideAPIKey(Keys.GooglePlaceKey)
		
		UIApplication.shared.statusBarStyle = .lightContent
		return true
	}
}

