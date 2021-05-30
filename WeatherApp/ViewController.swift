//
//  ViewController.swift
//  WeatherApp
//
//  Created by Konstantin Dmitrievskiy on 30.05.2021.
//

import UIKit

class ViewController: UIViewController {
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
        searchTextField.delegate = self

    }
    @IBAction private func locationButtonPressed(_ sender: UIButton) {
    }
    @IBAction private func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
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


