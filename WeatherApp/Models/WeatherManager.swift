//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Konstantin Dmitrievskiy on 30.05.2021.
//

import CoreLocation
import RxRelay
import RxSwift
import UIKit

struct WeatherManager {
    var forecast = PublishRelay<WeatherModel>()
    private let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=3d114828fe6a1721ff802023a7e9cf08&units=metric"

    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }

    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }

    private func performRequest(with urlString: String) {
        if let fixedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if  let url = URL(string: fixedURLString) {
                let session = URLSession(configuration: .default)

                let task = session.dataTask(with: url) { data, _, error in
                    if error != nil {
                        print("Can't find data")
                        return
                    }
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            forecast.accept(weather)
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
            let date = String(decodedData.list[0].dt)
            let id = decodedData.list[0].weather[0].id
            let description = decodedData.list[0].weather[0].description
            let list = decodedData.list

            let weather = WeatherModel(id: id, city: cityName, temp: temp, date: date, humidity: humidity, wind: speed, description: description, weatherList: list)
            return weather
        } catch {
            assert(true, "Can't load data")
            return nil
        }
    }
}
