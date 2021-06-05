//
//  HourlyTableViewCell.swift
//  WeatherApp
//
//  Created by Konstantin Dmitrievskiy on 30.05.2021.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    static let identifier = "HourlyTableViewCell"
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

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
