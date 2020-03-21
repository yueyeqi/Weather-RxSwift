//
//  WeatherModel.swift
//  Weather
//
//  Created by yueyeqi on 8/26/16.
//  Copyright © 2016 yueyeqi. All rights reserved.
//

import Foundation
import ObjectMapper

extension Mappable {
    
    var transform: TransformOf<String, Any> {
        return TransformOf<String, Any>(fromJSON: { (anyValue) -> String? in
            if let intValue = anyValue as? Int {
                return String(intValue)
            }
            
            if let strValue = anyValue as? String {
                return strValue
            }
            
            return nil
            
        }) { (strValue) -> String? in
            guard let strValue = strValue else { return nil }
            return String(strValue)
        }
    }
    
}

class WeatherModel : NSObject, NSCoding, Mappable{

    var heWeather6 : [HeWeather6]?


    class func newInstance(map: Map) -> Mappable?{
        return WeatherModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        heWeather6 <- map["HeWeather6"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         heWeather6 = aDecoder.decodeObject(forKey: "HeWeather6") as? [HeWeather6]

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if heWeather6 != nil{
            aCoder.encode(heWeather6, forKey: "HeWeather6")
        }

    }

}

class HeWeather6 : NSObject, NSCoding, Mappable{

    var basic : Basic?
    var dailyForecast : [DailyForecast]?
    var status : String?
    var update : Update?


    class func newInstance(map: Map) -> Mappable?{
        return HeWeather6()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        basic <- map["basic"]
        dailyForecast <- map["daily_forecast"]
        status <- (map["status"], transform)
        update <- map["update"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         basic = aDecoder.decodeObject(forKey: "basic") as? Basic
         dailyForecast = aDecoder.decodeObject(forKey: "daily_forecast") as? [DailyForecast]
         status = aDecoder.decodeObject(forKey: "status") as? String
         update = aDecoder.decodeObject(forKey: "update") as? Update

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if basic != nil{
            aCoder.encode(basic, forKey: "basic")
        }
        if dailyForecast != nil{
            aCoder.encode(dailyForecast, forKey: "daily_forecast")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if update != nil{
            aCoder.encode(update, forKey: "update")
        }

    }

}

class Update : NSObject, NSCoding, Mappable{

    var loc : String?
    var utc : String?


    class func newInstance(map: Map) -> Mappable?{
        return Update()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        loc <- (map["loc"], transform)
        utc <- (map["utc"], transform)
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         loc = aDecoder.decodeObject(forKey: "loc") as? String
         utc = aDecoder.decodeObject(forKey: "utc") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if loc != nil{
            aCoder.encode(loc, forKey: "loc")
        }
        if utc != nil{
            aCoder.encode(utc, forKey: "utc")
        }

    }

}

class DailyForecast : NSObject, NSCoding, Mappable{

    var condCodeD : String?
    var condCodeN : String?
    var condTxtD : String?
    var condTxtN : String?
    var date : String?
    var hum : String?
    var mr : String?
    var ms : String?
    var pcpn : String?
    var pop : String?
    var pres : String?
    var sr : String?
    var ss : String?
    var tmpMax : String?
    var tmpMin : String?
    var uvIndex : String?
    var vis : String?
    var windDeg : String?
    var windDir : String?
    var windSc : String?
    var windSpd : String?


    class func newInstance(map: Map) -> Mappable?{
        return DailyForecast()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        condCodeD <- (map["cond_code_d"], transform)
        condCodeN <- (map["cond_code_n"], transform)
        condTxtD <- (map["cond_txt_d"], transform)
        condTxtN <- (map["cond_txt_n"], transform)
        date <- (map["date"], transform)
        hum <- (map["hum"], transform)
        mr <- (map["mr"], transform)
        ms <- (map["ms"], transform)
        pcpn <- (map["pcpn"], transform)
        pop <- (map["pop"], transform)
        pres <- (map["pres"], transform)
        sr <- (map["sr"], transform)
        ss <- (map["ss"], transform)
        tmpMax <- (map["tmp_max"], transform)
        tmpMin <- (map["tmp_min"], transform)
        uvIndex <- (map["uv_index"], transform)
        vis <- (map["vis"], transform)
        windDeg <- (map["wind_deg"], transform)
        windDir <- (map["wind_dir"], transform)
        windSc <- (map["wind_sc"], transform)
        windSpd <- (map["wind_spd"], transform)
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         condCodeD = aDecoder.decodeObject(forKey: "cond_code_d") as? String
         condCodeN = aDecoder.decodeObject(forKey: "cond_code_n") as? String
         condTxtD = aDecoder.decodeObject(forKey: "cond_txt_d") as? String
         condTxtN = aDecoder.decodeObject(forKey: "cond_txt_n") as? String
         date = aDecoder.decodeObject(forKey: "date") as? String
         hum = aDecoder.decodeObject(forKey: "hum") as? String
         mr = aDecoder.decodeObject(forKey: "mr") as? String
         ms = aDecoder.decodeObject(forKey: "ms") as? String
         pcpn = aDecoder.decodeObject(forKey: "pcpn") as? String
         pop = aDecoder.decodeObject(forKey: "pop") as? String
         pres = aDecoder.decodeObject(forKey: "pres") as? String
         sr = aDecoder.decodeObject(forKey: "sr") as? String
         ss = aDecoder.decodeObject(forKey: "ss") as? String
         tmpMax = aDecoder.decodeObject(forKey: "tmp_max") as? String
         tmpMin = aDecoder.decodeObject(forKey: "tmp_min") as? String
         uvIndex = aDecoder.decodeObject(forKey: "uv_index") as? String
         vis = aDecoder.decodeObject(forKey: "vis") as? String
         windDeg = aDecoder.decodeObject(forKey: "wind_deg") as? String
         windDir = aDecoder.decodeObject(forKey: "wind_dir") as? String
         windSc = aDecoder.decodeObject(forKey: "wind_sc") as? String
         windSpd = aDecoder.decodeObject(forKey: "wind_spd") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if condCodeD != nil{
            aCoder.encode(condCodeD, forKey: "cond_code_d")
        }
        if condCodeN != nil{
            aCoder.encode(condCodeN, forKey: "cond_code_n")
        }
        if condTxtD != nil{
            aCoder.encode(condTxtD, forKey: "cond_txt_d")
        }
        if condTxtN != nil{
            aCoder.encode(condTxtN, forKey: "cond_txt_n")
        }
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
        if hum != nil{
            aCoder.encode(hum, forKey: "hum")
        }
        if mr != nil{
            aCoder.encode(mr, forKey: "mr")
        }
        if ms != nil{
            aCoder.encode(ms, forKey: "ms")
        }
        if pcpn != nil{
            aCoder.encode(pcpn, forKey: "pcpn")
        }
        if pop != nil{
            aCoder.encode(pop, forKey: "pop")
        }
        if pres != nil{
            aCoder.encode(pres, forKey: "pres")
        }
        if sr != nil{
            aCoder.encode(sr, forKey: "sr")
        }
        if ss != nil{
            aCoder.encode(ss, forKey: "ss")
        }
        if tmpMax != nil{
            aCoder.encode(tmpMax, forKey: "tmp_max")
        }
        if tmpMin != nil{
            aCoder.encode(tmpMin, forKey: "tmp_min")
        }
        if uvIndex != nil{
            aCoder.encode(uvIndex, forKey: "uv_index")
        }
        if vis != nil{
            aCoder.encode(vis, forKey: "vis")
        }
        if windDeg != nil{
            aCoder.encode(windDeg, forKey: "wind_deg")
        }
        if windDir != nil{
            aCoder.encode(windDir, forKey: "wind_dir")
        }
        if windSc != nil{
            aCoder.encode(windSc, forKey: "wind_sc")
        }
        if windSpd != nil{
            aCoder.encode(windSpd, forKey: "wind_spd")
        }

    }

}

class Basic : NSObject, NSCoding, Mappable{

    var adminArea : String?
    var cid : String?
    var cnty : String?
    var lat : String?
    var location : String?
    var lon : String?
    var parentCity : String?
    var tz : String?


    class func newInstance(map: Map) -> Mappable?{
        return Basic()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        adminArea <- (map["admin_area"], transform)
        cid <- (map["cid"], transform)
        cnty <- (map["cnty"], transform)
        lat <- (map["lat"], transform)
        location <- (map["location"], transform)
        lon <- (map["lon"], transform)
        parentCity <- (map["parent_city"], transform)
        tz <- (map["tz"], transform)
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         adminArea = aDecoder.decodeObject(forKey: "admin_area") as? String
         cid = aDecoder.decodeObject(forKey: "cid") as? String
         cnty = aDecoder.decodeObject(forKey: "cnty") as? String
         lat = aDecoder.decodeObject(forKey: "lat") as? String
         location = aDecoder.decodeObject(forKey: "location") as? String
         lon = aDecoder.decodeObject(forKey: "lon") as? String
         parentCity = aDecoder.decodeObject(forKey: "parent_city") as? String
         tz = aDecoder.decodeObject(forKey: "tz") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if adminArea != nil{
            aCoder.encode(adminArea, forKey: "admin_area")
        }
        if cid != nil{
            aCoder.encode(cid, forKey: "cid")
        }
        if cnty != nil{
            aCoder.encode(cnty, forKey: "cnty")
        }
        if lat != nil{
            aCoder.encode(lat, forKey: "lat")
        }
        if location != nil{
            aCoder.encode(location, forKey: "location")
        }
        if lon != nil{
            aCoder.encode(lon, forKey: "lon")
        }
        if parentCity != nil{
            aCoder.encode(parentCity, forKey: "parent_city")
        }
        if tz != nil{
            aCoder.encode(tz, forKey: "tz")
        }

    }

}
