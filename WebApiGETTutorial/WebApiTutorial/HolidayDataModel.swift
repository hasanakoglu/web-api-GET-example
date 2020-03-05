//
//  HolidayDataModel.swift
//  WebApiTutorial
//
//  Created by Hasan on 21/10/2019.
//  Copyright © 2019 Hasan. All rights reserved.
//

import Foundation

//Decodable to get from the api, Encodable to post

struct HolidayResponse: Decodable {
    var response:Holidays
}

struct Holidays: Decodable {
    var holidays:[HolidayDetail]
}

struct HolidayDetail: Decodable {
    var name: String
    var date: DateInfo
}


struct DateInfo: Decodable {
    var iso:String
}

//These 4 is primary for you to map your api response.
