//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Vanags, Edgars on 8/9/17.
//  Copyright © 2017 Vanags, Edgars. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var degreeLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var tableView: UITableView!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var blockingView: UIView!
	@IBOutlet weak var topView: UIView!

    private var model = WeatherModel()
    private var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = Int(DAY_COUNT_F)!
		if model.forecasts.count > 0 && model.forecasts.count <= count {
			return count - 1
		} else if (model.forecasts.count > count){
			return count - 1
		} else {
			return 0
		}
	}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell {
			cell.iconView.image = UIImage(named: self.model.weatherTypeF[indexPath.row + 1])
			cell.dayLabel.text = self.model.dateF[indexPath.row + 1]
			cell.weatherLabel.text = self.model.forecasts[indexPath.row + 1]
			cell.maxDegreeLabel.text = self.model.highTempF[indexPath.row + 1]
			cell.minDegreeLabel.text = self.model.lowTempF[indexPath.row + 1]
			
			return cell
		} else {
			return WeatherTableViewCell()
		}
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed: \(error.localizedDescription)")
        let errorAlert = UIAlertController(title: "Error!", message: "Failed to retrieve location", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default , handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location: CLLocationCoordinate2D = (manager.location?.coordinate)!
		Location.shared.latitude = location.latitude
		Location.shared.longitude = location.longitude
		
		model.downloadWeatherDetails {
			self.model.downloadForecastData {
				self.updateUI()
				self.tableView.reloadData()
				self.ready()
			}
		}
		locationManager.stopUpdatingLocation()
	}
	
	func ready() {
		blockingView.isHidden = true
		if spinner.isAnimating {
			spinner.stopAnimating()
		}
	}

    func updateUI() {
        dateLabel.text = model.date
        locationLabel.text = model.cityName
        degreeLabel.text = String(model.currentTemperature)
        weatherLabel.text = model.weatherType
        imageView.image = UIImage(named: model.weatherType)
    }
}

