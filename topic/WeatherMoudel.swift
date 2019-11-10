//
//  File.swift
//  topic
//
//  Created by 許維倫 on 2019/11/5.
//  Copyright © 2019 許維倫. All rights reserved.
//

import Foundation
// 現在天氣
class Weather: Codable {
    var tempNow: String
    var uviH: String?
    var uviStatus: String?
    var tempMax: String?
    var tempMin: String?
    init() {
        tempNow = ""
        uviH = ""
        uviStatus = ""
        tempMax = ""
        tempMin = ""
    }
}
