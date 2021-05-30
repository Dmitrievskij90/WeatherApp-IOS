//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Konstantin Dmitrievskiy on 30.05.2021.
//

import Foundation

struct WeatherData: Codable {
    let list: [List]
    let city: City

}

struct List: Codable {
    let main: Main
    let wind: Wind
    let weather: [Weather]
    let dt_txt: String
    let dt: Int
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct City: Codable{
    let name: String
}
