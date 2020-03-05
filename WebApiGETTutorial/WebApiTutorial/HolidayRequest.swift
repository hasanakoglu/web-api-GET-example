//
//  HolidayRequest.swift
//  WebApiTutorial
//
//  Created by Hasan on 21/10/2019.
//  Copyright © 2019 Hasan. All rights reserved.
//

import Foundation

enum HolidayError: Error {
    case noData
    case noProcessedData
}

struct HolidayRequest {
    let resourceURL:URL
    let API_KEY = "2d53bf62e146614d2578bf2158f2675d95a56ef3"

    init(countryCode: String) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let currentYear = format.string(from: date)


        let resourceString = "https://calendarific.com/api/v2/holidays?api_key=\(API_KEY)&Country=\(countryCode)&year=\(currentYear)"

        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }

    // Result type in swift 5 has either a success or failure, our success being the holiday details array & failure being the error that our api can return
    func getHolidays(completion: @escaping(Result<[HolidayDetail], HolidayError>) -> Void) {
        // added void as there is no return type
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data,_,_ in
            //data and error response
            // this is asynchronous as it takes time to retrieve form the web

            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }

            do {
                // we use this decoder to decode our adjacent data with the format we specified in our data model.
                let decoder = JSONDecoder()
                let holidayResponse = try decoder.decode(HolidayResponse.self, from: jsonData) // using try as something could go wring with decoder
                let holidayDetails = holidayResponse.response.holidays
                completion(.success(holidayDetails))


            }catch{
                completion(.failure(.noProcessedData))
            }
        }
        dataTask.resume() //to download and access the api
    }
}
