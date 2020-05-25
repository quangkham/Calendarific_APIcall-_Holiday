//
//  HolidayRequest.swift
//  WeatherAPI
//
//  Created by Quang Kham on 22/05/2020.
//  Copyright © 2020 Quang Kham. All rights reserved.
//

import Foundation


enum ResponseError : Error{
    case notDatAvailabel
    case noProcessData
}
struct HolidayRequest {
    
    let resourceURL : URL
    let API_Key = "2989b78fd1aefa7925452684ebdef34e6178e232"
    let Holiday_List_API = Api.Host.baseURL + Api.Endpoint.holiday
    
    init(countryCode : String){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let currentYear = formatter.string(from: date)
        let resourceURLString = "https://calendarific.com/api/v2/holidays?&api_key=\(API_Key)&country=\(countryCode)&year=\(currentYear)"
        
        guard let resourceURL = URL(string: resourceURLString) else{
            fatalError()
        }
        
        self.resourceURL = resourceURL
        var request = URLRequest(url: resourceURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        
    }
    
    
    mutating func getHolidays(completion : @escaping (Result<[HolidayDetail] , Error>) -> Void ){
        var holidayList = [HolidayDetail]()
        let dataTaks = URLSession.shared.dataTask(with: resourceURL) { (data, _, _) in
            guard let jsonData = data else {
                completion(.failure(ResponseError.notDatAvailabel))
                return
            }
            do{
                
                let holidayJsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                    as? [String:Any]
                let holidayResponse = holidayJsonObject!["response"] as! [String :Any]
                let hoidayDetails = holidayResponse ["holidays"] as! [AnyObject]
                for holidayDetail in hoidayDetails{
                    var holiday = HolidayDetail()
                    holiday!.name = holidayDetail["name"] as! String
                    let date = holidayDetail["date"] as! [String : Any]
                    holiday?.iso = date["iso"] as! String
                    holidayList.append(holiday!)
                }
                completion(.success(holidayList))
                print(hoidayDetails)
            }
            catch {
                completion(.failure(ResponseError.noProcessData))
            }
        }
        dataTaks.resume()
    }
}

//1st method

//                let decoder = JSONDecoder()
//                let holidayResponse = try decoder.decode(HolidayResponse.self, from: jsonData)
//                let holidayDetails = holidayResponse.response.holidays
//                completion(.success(holidayDetails))
