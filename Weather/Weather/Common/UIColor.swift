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
    class func colorWithHex(hexStr: String) -> UIColor {
        var formatStr: String!
        if let index = hexStr.rangeOfString("0X") {
            formatStr = hexStr.substringFromIndex(index.endIndex)
        } else if let index = hexStr.rangeOfString("#") {
            formatStr = hexStr.substringFromIndex(index.endIndex)
        } else if hexStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 6 {
            formatStr = hexStr
        }
        
        if formatStr == nil {
            return UIColor.whiteColor()
        }
        
        let rString = formatStr.substringWithRange(Range<String.Index>(formatStr.startIndex ..< formatStr.startIndex.advancedBy(2)))
        let gString = formatStr.substringWithRange(Range<String.Index>(formatStr.startIndex.advancedBy(2) ..< formatStr.startIndex.advancedBy(4)))
        let bString = formatStr.substringWithRange(Range<String.Index>(formatStr.startIndex.advancedBy(4) ..< formatStr.endIndex))
        
        // Scan values
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }

}