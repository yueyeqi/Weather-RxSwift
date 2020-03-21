//
//  WeatherAPI.swift
//  Weather
//
//  Created by yueyeqi on 8/26/16.
//  Copyright © 2016 yueyeqi. All rights reserved.
//

import Foundation
import Moya

let MyWeatherKey: String = "e77317f54f364ef68fb874fd267635ff"
let WeatherProvider = MoyaProvider<WeatherAPI>()
public var CityName = "chengdu"

public enum WeatherAPI {
    case now
}

extension WeatherAPI: TargetType {
    
    public var baseURL: URL {
        let str: String = "https://free-api.heweather.net/s6/weather/forecast?"
        let queryItem1 = NSURLQueryItem(name: "location", value: CityName)
        let queryItem2 = NSURLQueryItem(name: "key", value: MyWeatherKey)
        let urlCom = NSURLComponents(string: str)
        urlCom?.queryItems = [(queryItem1 as URLQueryItem), (queryItem2 as URLQueryItem)]
        return (urlCom?.url!)!
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        .get
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .now:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}
