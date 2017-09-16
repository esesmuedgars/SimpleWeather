//
//  Location.swift
//  WeatherApplication
//
//  Created by Edgars Vanags on 15/09/2017.
//  Copyright © 2017 Edgars Vanags. All rights reserved.
//

import CoreLocation

final class Location {
	private init() {}
	
	static let shared = Location()
	
	var latitude: Double!
	var longitude: Double!
}
