//
//  ViewController.swift
//  WeatherApp
//
//  Created by Konstantin Dmitrievskiy on 30.05.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    private var dataSourse = [List]()

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

        //нужно устанавливать раньше requestWhenInUseAuthorization и requestLocation иначе будет ошибка
        locationManager.delegate = self

        //данным способом мы запрашиваем разрешение на отслеживание локации пользователя. Так же в файле info.plist нужно добавить свойство "Privacy When In Use Usage Description" и прописать в валью сообщение
        locationManager.requestWhenInUseAuthorization()

    // так мы получаем локацию пользователя. Чтобы всега обновлять локацию пользователя (к примеру когда он движется на машине или бежит) нужно использовать другой метод startUpdatingLocation().
        locationManager.requestLocation()

        weatherTableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
    }
    
    @IBAction private func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
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
            textField.placeholder = "Enter the city"
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                textField.placeholder = "Search"
            }
            return false
        }
    }

}

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.descriptionLabel.text = weather.description
            self.temperatureLabel.text = "\(weather.temperatureString)°"
            self.humidityLabel.text = (weather.humidityString)
            self.windLabel.text = weather.windSpeedString
            self.conditionImageVIew.image = UIImage(named: weather.conditionName)
            self.dataSourse = weather.weatherList
            self.weatherTableView.reloadData()
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSourse.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as? HourlyTableViewCell else {
            return UITableViewCell()
        }

        let date = getCurrentDate(dataSourse[indexPath.row].dt)
        let temperature = String(format: "%.1f", dataSourse[indexPath.row].main.temp)
        guard let image = UIImage(named: getConditionName(id: dataSourse[indexPath.row].weather[0].id)) else {
            assert(false, "Can't find image")
        }

        cell.dateLabel.text = date
        cell.temperatureLabel.text = "\(temperature)°"
        cell.conditionImageView.image = image

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: CLLocationManagerDelegate {

    //в симуляторе, чтобы локация работала в нужно пройти в Simulator > Features > Location > Custom Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //останавливаем обновление локации чтобы можно было обновлять локацию через кнопку локации
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


