//
//  UrlSessionDelegate.swift
//  topic
//
//  Created by 許維倫 on 2019/10/7.
//  Copyright © 2019 許維倫. All rights reserved.
//

import Foundation
protocol UrlSessionDelegate {
    func SessionFinish(data:NSData)
    func SessionFinishError(error:NSError)
}
