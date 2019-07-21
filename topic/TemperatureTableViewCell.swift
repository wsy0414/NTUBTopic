//
//  TemperatureTableViewCell.swift
//  topic
//
//  Created by 許維倫 on 2019/7/17.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit

class TemperatureTableViewCell: UITableViewCell {
    @IBOutlet weak var temperatureTitle: UILabel!
    @IBOutlet weak var bodyTemTitle: UILabel!
    @IBOutlet weak var temperatureValue: UILabel!
    @IBOutlet weak var bodytemValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
