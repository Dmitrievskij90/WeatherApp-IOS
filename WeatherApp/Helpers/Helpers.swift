//
//  Helpers.swift
//  WeatherApp
//
//  Created by Konstantin Dmitrievskiy on 20.02.2022.
//

import Foundation

class Helpers {
    static let shared = Helpers()
    private lazy var dateFormatter = DateFormatter()

    func getCurrentDate(_ date: Int) -> String {
        let unixTimestamp = Double(date)
        let date = Date(timeIntervalSince1970: unixTimestamp)
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = Constants.dateFormat
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
