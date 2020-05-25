//
//  Holidays.swift
//  WeatherAPI
//
//  Created by Quang Kham on 22/05/2020.
//  Copyright © 2020 Quang Kham. All rights reserved.
//

import Foundation

struct HolidayResponse {
    var response : Holidays
    
}
struct Holidays  {
    var holidays : [HolidayDetail]
}

class HolidayDetail {
    
    var name : String?
    //var date : DateInfo?
    var type : String?
    var iso : String?
    
    required init?(){
        
    }
}

struct DateInfo {
    var iso : String
    
}
