//
//  UIColor.swift
//  Facebook-Pop
//
//  Created by yueyeqi on 8/19/16.
//  Copyright © 2016 yueyeqi. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func colorWithHex(hexStr: String) -> UIColor? {
        if hexStr.count <= 0 || hexStr.count != 7 || hexStr == "(null)" || hexStr == "<null>" {
            return nil
        }
        var red: UInt32 = 0x0
        var green: UInt32 = 0x0
        var blue: UInt32 = 0x0
        let redString = String(hexStr[hexStr.index(hexStr.startIndex, offsetBy: 1)...hexStr.index(hexStr.startIndex, offsetBy: 2)])
        let greenString = String(hexStr[hexStr.index(hexStr.startIndex, offsetBy: 3)...hexStr.index(hexStr.startIndex, offsetBy: 4)])
        let blueString = String(hexStr[hexStr.index(hexStr.startIndex, offsetBy: 5)...hexStr.index(hexStr.startIndex, offsetBy: 6)])
        Scanner(string: redString).scanHexInt32(&red)
        Scanner(string: greenString).scanHexInt32(&green)
        Scanner(string: blueString).scanHexInt32(&blue)
        let hexColor = UIColor.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
        return hexColor
    }
}
