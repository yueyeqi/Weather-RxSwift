//
//  WeatherAPI.swift
//  Weather
//
//  Created by yueyeqi on 8/26/16.
//  Copyright © 2016 yueyeqi. All rights reserved.
//

import Foundation
import Moya

let MyWeatherKey: String = "b4f610fb3177461784c82122332f62ae"
let WeatherProvider = RxMoyaProvider<WeatherAPI>()
public var CityName = "大同"

public enum WeatherAPI {
    case now
}

extension WeatherAPI: TargetType {
    
    public var baseURL: NSURL {
        let str: String = "https://api.heweather.com/x3/weather?"
        let queryItem1 = NSURLQueryItem(name: "city", value: CityName)
        let queryItem2 = NSURLQueryItem(name: "key", value: MyWeatherKey)
        let urlCom = NSURLComponents(string: str)
        urlCom?.queryItems = [queryItem1, queryItem2]
        return (urlCom?.URL!)!
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        return .GET
    }
    
    public var parameters: [String : AnyObject]? {
        return nil
    }
    
    public var sampleData: NSData {
        return "123".dataUsingEncoding(NSUTF8StringEncoding)!
    }
    
    public var multipartBody: [MultipartFormData]? {
        return nil
    }
}
