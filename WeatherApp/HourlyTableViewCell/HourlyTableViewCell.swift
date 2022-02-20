//
//  HourlyTableViewCell.swift
//  WeatherApp
//
//  Created by Konstantin Dmitrievskiy on 30.05.2021.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    static let identifier = "HourlyTableViewCell"
    var data: List? {
        didSet {
            if let weatherData = data {
                let date = Helpers.shared.getCurrentDate(weatherData.dt)
                let temperature = String(format: "%.1f", weatherData.main.temp)

                guard let image = UIImage(named: WeatherModel.getHourlyConditionName(id: weatherData.weather[0].id)) else {
                    assert(false, "Can't find image")
                }

                dateLabel.text = date
                temperatureLabel.text = "\(temperature)°"
                conditionImageView.image = image
            }
        }
    }

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!

    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
