//
//  OilPriceTableViewCell.swift
//  topic
//
//  Created by 許維倫 on 2019/5/13.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit

class OilPriceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /*
    func setup() {
        let labelLeft = NSLayoutConstraint(item: self.priceLabel!, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .leading, multiplier: 1, constant: 320)
        let labelRight = NSLayoutConstraint(item: self.priceLabel!, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: self, attribute: .trailing, multiplier: 1, constant: -10)
        let labelBottom = NSLayoutConstraint(item: self.priceLabel!, attribute: .bottom, relatedBy: .equal, toItem:
    }
    */
}
