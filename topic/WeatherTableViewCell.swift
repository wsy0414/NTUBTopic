//
//  WeatherTableViewCell.swift
//  topic
//
//  Created by 許維倫 on 2019/5/20.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var uviLabel: UILabel!
    @IBOutlet weak var aqivalueLabel: UILabel!
    @IBOutlet weak var uvivalueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
