//
//  ViewController.swift
//  topic
//
//  Created by 許維倫 on 2019/5/13.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    let locationManager:CLLocationManager = CLLocationManager() // 設定定位管理器
    
    @IBOutlet weak var mainTableView: UITableView! // 主畫面的TableView
    @IBOutlet weak var gpsLabel: UILabel! // 地理資訊
    // button切換Section設定畫面
    @IBAction func toSectionset(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goSectionset", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self //設定服務代理
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 設定最佳精確度
        locationManager.distanceFilter = 100 // 距離多遠更新一次
        locationManager.requestAlwaysAuthorization() // 取得gps授權
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            print("取得位置")
        }else{
            print("失敗")
        }
        
       mainTableView.register(UINib(nibName: "OilPriceTableViewCell", bundle: nil), forCellReuseIdentifier: "OilPriceCell")
       mainTableView.register(UINib(nibName: "TruthcarTableViewCell", bundle: nil), forCellReuseIdentifier: "TruthcarCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.reloadData()
    }
    
    // TableView
    var tableViewSection = ["節慶","油價", "垃圾車", "疾病"]
    var tableViewRow = [["端午節"],
                       ["92無鉛", "95無鉛", "98無鉛", "柴油"],
                       ["時間"],
                       ["登革熱"]]
    var priceArray = ["20", "30", "40", "50"]

    // 要有幾個section
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSection.count
    }
    
    // 每個section有幾列
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRow[section].count
    }
    
    // 產出cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableViewSection[indexPath.section] == "油價"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OilPriceCell", for: indexPath)as! OilPriceTableViewCell
            cell.textLabel?.text = tableViewRow[indexPath.section][indexPath.row]
            cell.priceLabel.text = priceArray[indexPath.row]
            // cell.PriceLabel.bounds = CGRect(x: 300, y: 10, width: 40, height: 30)
            print(cell.priceLabel.bounds)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TruthcarCell", for: indexPath)as! TruthcarTableViewCell
            cell.textLabel?.text = tableViewRow[indexPath.section][indexPath.row]
            return cell
        }
        
    }
    
    // 設定header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return tableViewSection[section]
    }
    
    //設定header的字型
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // 處理最近的位置更新
    func locationManager(_ manger: CLLocationManager, didUpdateLocations location:[CLLocation]){
        locationManager.delegate = self
        
        let curLocation: CLLocation = location.last! // 取得最新的經緯度
        print("經度緯度：\(curLocation.coordinate.longitude)緯度\(curLocation.coordinate.latitude)")
        
        // 經緯度轉換成地址
        let geoCoder = CLGeocoder() //
        geoCoder.reverseGeocodeLocation(curLocation, preferredLocale: nil , completionHandler: {(placemarks, error) -> Void in
                // 失敗 回傳空值
                if error != nil { 
                    return
                }
                /*  name            街道地址
                 *  country         國家
                 *  province        省籍
                 *  locality        萬華區
                 *  route           街道、路名
                 *  streetNumber    門牌號碼
                 *  postalCode      郵遞區號
                 */
                // 回傳地理資訊
                if placemarks != nil && (placemarks?.count)! > 0{
                    let placemark = (placemarks?[0])! as CLPlacemark
                    //這邊拼湊轉回來的地址
                    self.gpsLabel.text = placemark.locality // 顯
                }
        })
    }
    
}






