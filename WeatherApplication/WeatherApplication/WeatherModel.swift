//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Vanags, Edgars on 8/9/17.
//  Copyright © 2017 Vanags, Edgars. All rights reserved.
//

import Alamofire

class WeatherModel {
	private var _cityName: String!
	private var _date: String!
	private var _weatherType: String!
	private var _currentTemperature: String!
	
	private var _dateF = [String]()
	private var _weatherTypeF = [String]()
	private var _lowTempF = [String]()
	private var _highTempF = [String]()
	private var _forecasts = [String]()
	
	var cityName: String {
		if _cityName == nil {
			_cityName = "Location"
		}
		return _cityName
	}
	
	var date: String {
		if _date == nil {
			_date = "Date"
		}
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .none
		let currentDate = dateFormatter.string(from: Date())
		self._date = "Today, \(currentDate)"
		
		return _date
	}
	
	var weatherType: String {
		if _weatherType == nil {
			_weatherType = "Clear"
		}
		return _weatherType
	}
	
	var currentTemperature: String {
		if _currentTemperature == nil {
			_currentTemperature = "0.0"
		}
		return _currentTemperature
	}
	
	var dateF: [String] {
		get {
			return _dateF
		}
		set {
			_dateF = newValue
		}
	}
	
	var weatherTypeF: [String] {
		get {
			return _weatherTypeF
		}
		set {
			_weatherTypeF = newValue
		}
	}
	
	var lowTempF: [String] {
		get {
			return _lowTempF
		}
		set {
			_lowTempF = newValue
		}
	}
	
	var highTempF: [String] {
		get {
			return _highTempF
		}
		set {
			_highTempF = newValue
		}
	}
	
	var forecasts: [String] {
		get {
			return _forecasts
		}
		set {
			_forecasts = newValue
		}
	}
	
	func downloadWeatherDetails(completed: @escaping DownloadComplete) {
		let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
		Alamofire.request(currentWeatherURL).responseJSON { response in
			let result = response.result
			
			if let dict = result.value as? Dictionary<String, AnyObject> {
				
				if let name = dict["name"] as? String,
					let sys = dict["sys"] as? Dictionary<String, AnyObject>,
					let country = sys["country"] as? String {
					self._cityName = "\(name.capitalized), \(country)"
				}
				
				if let weather = dict["weather"] as? [Dictionary<String, AnyObject>],
					let main = weather[0]["main"] as? String {
					self._weatherType = main.capitalized
				}
				
				if let main = dict["main"] as? Dictionary<String, AnyObject>,
					let temp = main["temp"] as? Double {
					self._currentTemperature = "\(Double(temp - 273.15).rounded(toPlaces: 2))°"
				}
			}
			completed()
		}
	}
	
	func downloadForecastData(completed: @escaping DownloadComplete) {
		let forecastWeatherURL = URL(string: FORECAST_WEATHER_URL)!
		Alamofire.request(forecastWeatherURL).responseJSON { response in
			let result = response.result
			
			if let dict = result.value as? Dictionary<String, AnyObject> {
				
				if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
					for date in list {
						if let date = date["dt"] as? Double {
							let unixConvertedDate = Date(timeIntervalSince1970: date)
							let dateFormatter = DateFormatter()
							dateFormatter.dateStyle = .full
							dateFormatter.dateFormat = "EEEE"
							dateFormatter.timeStyle = .none
							self._dateF.append(String(describing: unixConvertedDate.dayOfTheWeek()))
						}
					}
					
					for weather in list {
						if let weather = weather["weather"] as? [Dictionary<String, AnyObject>],
							let main = weather[0]["main"] as? String {
							self._forecasts.append(main.capitalized)
							self._weatherTypeF.append("\(main.capitalized) Mini")
						}
					}
					
					for temp in list {
						if let temperature = temp["temp"] as? Dictionary<String, Double> {
							if let min = temperature["min"] {
								self._lowTempF.append("\((min - 273.15).rounded(toPlaces: 2))°")
							}
							
							if let max = temperature["max"] {
								self._highTempF.append("\((max - 273.15).rounded(toPlaces: 2))°")
							}
						}
					}
				}
			}
			completed()
		}
	}
}

extension Date {
	func dayOfTheWeek() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE"
		return dateFormatter.string(from: self)
	}
}

extension Double {
	func rounded(toPlaces places:Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
}
