//
//  Constants.swift
//  WeatherApp
//
//  Created by Vanags, Edgars on 8/9/17.
//  Copyright © 2017 Vanags, Edgars. All rights reserved.
//

// CURRENT_WEATHER
// api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid=68f16bc4e9d9a752257aab30ac5689c7
// {lat} - latitude, {lon} - longitude
let BASE_URL = "https://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat=\(Location.shared.latitude!)"
let LONGITUDE = "&lon=\(Location.shared.longitude!)"
let APP_ID = "&appid="
let API_KEY = "68f16bc4e9d9a752257aab30ac5689c7"

// WEATHER_FOR_FUTURE
// api.openweathermap.org/data/2.5/forecast/daily?lat={lat}&lon={lon}&cnt={cnt}&appid=68f16bc4e9d9a752257aab30ac5689c7
// {lat} - latitude, {lon} - longitude, {cnt} - 1...16 next days
let BASE_URL_F = "https://api.openweathermap.org/data/2.5/forecast/daily?"
let LINE_NUMBER_F = "&cnt="
let DAY_COUNT_F = "16"

let CURRENT_WEATHER_URL = BASE_URL+LATITUDE+LONGITUDE+APP_ID+API_KEY
let FORECAST_WEATHER_URL = BASE_URL_F+LATITUDE+LONGITUDE+LINE_NUMBER_F+DAY_COUNT_F+APP_ID+API_KEY

typealias DownloadComplete = () -> ()
