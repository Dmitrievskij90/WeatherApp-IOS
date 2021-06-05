//
//  ViewController.swift
//  WeatherApp
//
//  Created by Konstantin Dmitrievskiy on 30.05.2021.
//

import UIKit

class ViewController: UIViewController {
    private var weatherManager = WeatherManager()
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var conditionImageVIew: UIImageView!
    @IBOutlet weak var weatherTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
        weatherTableView.delegate = self
        weatherTableView.dataSource = self

        weatherTableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
    }
    
    @IBAction private func locationButtonPressed(_ sender: UIButton) {
    }

    @IBAction private func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }

    private func getCurrentDate(_ date: Int) -> String {
        let unixTimestamp = Double(date)
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = Constants.dateFormat
        let strDate = dateFormatter.string(from: date)
        return strDate
    }

    private func getConditionName(id: Int) -> String {
        switch id {
        case 200...232:
            return Constants.thunderstorm
        case 300...321:
            return Constants.drizzle
        case 500...531:
            return Constants.rain
        case 600...622:
            return Constants.snow
        case 701...781:
            return Constants.wind
        case 800:
            return Constants.sun
        case 801...803:
            return Constants.cloudy
        case 804:
            return Constants.clouds
        default:
            return Constants.sun
        }
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        searchTextField.text = ""

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }

        searchTextField.text = ""
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Tap something"
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                textField.placeholder = "Search"
            }
            return false
        }
    }

}

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.descriptionLabel.text = weather.description
            self.temperatureLabel.text = weather.temperatureString
            self.humidityLabel.text = (weather.humidityString)
            self.windLabel.text = weather.windSpeedString
            self.conditionImageVIew.image = UIImage(systemName: weather.conditionName)
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }


}


