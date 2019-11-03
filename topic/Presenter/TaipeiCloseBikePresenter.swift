//
//  TaipeiCloseBike.swift
//  topic
//
//  Created by 許維倫 on 2019/10/30.
//  Copyright © 2019 許維倫. All rights reserved.
//

import Foundation
class TaipeiCloseBikePresenter: BasePresenter{
    var process = 0
    var status = ""
    var delegate : ViewControllerBaseDelegate?
    init(delegate:ViewControllerBaseDelegate){
        self.delegate = delegate
    }
    func getCloseBike(Longitude:Double, Latitude: Double, type: String){
        switch type {
        case "1":
            status = "GetCloseBike"
            let urlsession = UrlSession(url: ServerContentURL.getCloseBike ,delegate:self)
            let jsonb = JSONBuilder()
            jsonb.addItem(key: "Longitude", value: Longitude)
            jsonb.addItem(key:"Latitude", value: Latitude)
            jsonb.addItem(key: "type", value: type)
            urlsession.setupJSON(json:jsonb.value())
            urlsession.postJSON()
        case "2":
            status = "GetCloseRentBike"
            let urlsession = UrlSession(url: ServerContentURL.getCloseBike ,delegate:self)
            let jsonb = JSONBuilder()
            jsonb.addItem(key: "Longitude", value: Longitude)
            jsonb.addItem(key:"Latitude", value: Latitude)
            jsonb.addItem(key: "type", value: type)
            urlsession.setupJSON(json:jsonb.value())
            urlsession.postJSON()
        case "3":
            status = "GetCloseReturnBike"
            let urlsession = UrlSession(url: ServerContentURL.getCloseBike ,delegate:self)
            let jsonb = JSONBuilder()
            jsonb.addItem(key: "Longitude", value: Longitude)
            jsonb.addItem(key:"Latitude", value: Latitude)
            jsonb.addItem(key: "type", value: type)
            urlsession.setupJSON(json:jsonb.value())
            urlsession.postJSON()
        default:
            break
        }
        
    }
    override func SessionFinish(data: NSData) {
        let urlsession = UrlSession()
        let jsondictionary = urlsession.jsonDictionary(json: data)
        let result = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        let temp_result = jsondictionary.object(forKey: "result") as! Bool
        
        if temp_result{
            delegate?.PresenterCallBack(datadic: jsondictionary, success: true, type: status)
        }else{
            delegate?.PresenterCallBack(datadic: jsondictionary, success: false,type:status)
        }
    }
    override func SessionFinishError(error: NSError) {
        delegate?.PresenterCallBackError(error: error, type: "")
    }
}
