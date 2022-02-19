//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Konstantin Dmitrievskiy on 30.05.2021.
//

import Foundation

struct WeatherModel {
    let id: Int
    let city: String
    let temp: Double
    let date: String
    let humidity: Int
    let wind: Double
    let description: String
    let weatherList: [List]

    var temperatureString: String {
        return String(format: "%.1f", temp)
    }

    var humidityString: String {
        return "Humidity: \(humidity) %"
    }

    var windSpeedString: String {
        return String("Wind: \(wind) m/s")
    }

    var currentConditionName: String {
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

    static func getHourlyConditionName(id: Int) -> String {
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
