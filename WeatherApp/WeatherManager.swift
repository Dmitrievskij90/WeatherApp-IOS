//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Konstantin Dmitrievskiy on 30.05.2021.
//


import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)

    func didFailWithError(error: Error)
}

struct WeatherManager {

    var delegate: WeatherManagerDelegate?

    private let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=3d114828fe6a1721ff802023a7e9cf08&units=metric"

    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)

    }

    private func performRequest(with urlString: String) {
        if let fixedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if  let url = URL(string: fixedURLString) {
                let session = URLSession(configuration: .default)

                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil{
                        print("Can't find data")
                        return
                    }
                    if let safeData = data {

                        if let weather = self.parseJSON(safeData) {
                            self.delegate?.didUpdateWeather(weather: weather)
                        }
                    }
                }
                task.resume()
            }
        }
    }

    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)

            let temp = decodedData.list[0].main.temp
            let cityName = decodedData.city.name
            let humidity = decodedData.list[0].main.humidity
            let speed = decodedData.list[0].wind.speed
            let date = decodedData.list[0].dt
            let id = decodedData.list[0].weather[0].id
            let description = decodedData.list[0].weather[0].description
            let list = decodedData.list

            let weather = WeatherModel(conditionID: id, cityName: cityName, temperature: temp, date: getCurrentDate(date), humidity: humidity, windSpeed: speed, description: description, weatherList: list)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }

    }

    private func getCurrentDate(_ date: Int) -> String {
        let unixTimestamp = Double(date)
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "EEE HH:mm"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
