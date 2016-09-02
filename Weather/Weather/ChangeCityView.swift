//
//  ChangeCityView.swift
//  Weather
//
//  Created by yueyeqi on 9/1/16.
//  Copyright © 2016 yueyeqi. All rights reserved.
//

import UIKit

class ChangeCityView: UIView {

    override func drawRect(rect: CGRect) {
        
        self.backgroundColor = UIColor.whiteColor()
        
        let cityLabel = UILabel(frame: CGRectMake(10, 10, 70, 20))
        cityLabel.text = "城市名称"
        self.addSubview(cityLabel)
        
        let cityTextFeild = UITextField(frame: CGRectMake(85, 10, 50, 20))
        self.addSubview(cityTextFeild)
        
        let cancelButton = UIButton(type: .System)
        cancelButton.frame = CGRectMake(10, 70, 50, 20)
        cancelButton.setTitle("取消", forState: .Normal)
        self.addSubview(cancelButton)
        
        let confirmButton = UIButton(type: .System)
        confirmButton.frame = CGRectMake(70, 70, 50, 20)
        confirmButton.setTitle("确认", forState: .Normal)
        self.addSubview(confirmButton)
    }
    
}
