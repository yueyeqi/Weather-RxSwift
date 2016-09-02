//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by yueyeqi on 8/30/16.
//  Copyright © 2016 yueyeqi. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxminLabel: UILabel!
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
