//
//  ServerContentURL.swift
//  topic
//
//  Created by 許維倫 on 2019/10/7.
//  Copyright © 2019 許維倫. All rights reserved.
//

import Foundation
class ServerContentURL {
    
    static var ip = "https://topic-ntub.herokuapp.com/"  // Heroku 主機端
    // static var ip = "http://127.0.0.1:8000/" // 本機端
    
    static var gasprice = ip + "gasprice/"
    static var aqi = ip + "aqi/"
    static var weather = ip + "weather/"
    static var environmentalWarning = ip + "warning/"
    static var preweather = ip + "preweather/"
    static var getAllBike = ip + "getAllBike/"
    static var getCloseBike = ip + "getCloseBike/"
    
}

