//
//  WeatherModel.swift
//  Weather
//
//  Created by yueyeqi on 8/26/16.
//  Copyright © 2016 yueyeqi. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

final class WeatherModel: ALSwiftyJSONAble {
    
    var city: String = ""
    var update: String = ""
    var aqi: String = ""
    var tmp: String = ""
    var max: String = ""
    var min: String = ""
    var code: String = ""
    var txt: String = ""
    var daily: [WeatherDetailModel] = []
    
    
    required init?(jsonData: JSON) {
        city = jsonData["HeWeather data service 3.0"][0]["basic"]["city"].stringValue
        update = jsonData["HeWeather data service 3.0"][0]["basic"]["update"]["loc"].stringValue
        aqi = jsonData["HeWeather data service 3.0"][0]["aqi"]["city"]["aqi"].stringValue
        tmp = jsonData["HeWeather data service 3.0"][0]["now"]["tmp"].stringValue
        max = jsonData["HeWeather data service 3.0"][0]["daily_forecast"][0]["tmp"]["max"].stringValue
        min = jsonData["HeWeather data service 3.0"][0]["daily_forecast"][0]["tmp"]["min"].stringValue
        code = jsonData["HeWeather data service 3.0"][0]["now"]["cond"]["code"].stringValue
        txt = jsonData["HeWeather data service 3.0"][0]["now"]["cond"]["txt"].stringValue
        if let _daily = jsonData["HeWeather data service 3.0"][0]["daily_forecast"].array {
            daily = _daily.flatMap({WeatherDetailModel(jsonData: $0)})
        }
    }
    
}

final class WeatherDetailModel: ALSwiftyJSONAble {
    
    var date: String = ""
    var max: String = ""
    var min: String = ""
    var txt: String = ""
    var code: String = ""
    
    required init?(jsonData: JSON) {
        date = jsonData["date"].stringValue
        max = jsonData["tmp"]["max"].stringValue
        min = jsonData["tmp"]["min"].stringValue
        txt = jsonData["cond"]["txt_d"].stringValue
        code = jsonData["cond"]["code_d"].stringValue
    }

}