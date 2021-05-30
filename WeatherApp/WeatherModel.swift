//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Konstantin Dmitrievskiy on 30.05.2021.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    let date: String
    let humidity: Int
    let windSpeed: Double
    let description: String

    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }

    var humidityString: String {
        return "Humidity: \(humidity) %"
    }

    var windSpeedString: String {
        return String("Wind: \(windSpeed) m/s")
    }

    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }

}



