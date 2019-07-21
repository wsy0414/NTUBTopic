//
//  ViewController.swift
//  topic
//
//  Created by 許維倫 on 2019/5/13.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    var priceArray: [String] = ["value", "value", "value", "value"] // 油價初始值
    
    var refreshControl: UIRefreshControl! // 宣告元件
    let locationManager: CLLocationManager = CLLocationManager() // 設定定位管理器
    
    @IBOutlet weak var mainTableView: UITableView! // 主畫面的TableView
    @IBOutlet weak var gpsLabel: UILabel! // 地理資訊
    
    // button切換Section設定畫面
    @IBAction func toSectionset(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goSectionset", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
        // 初始化更新元件
        refreshControl = UIRefreshControl()
        mainTableView.addSubview(refreshControl)  // 加到tableview裡
        
        // 註冊自定義tableViewCell
        mainTableView.register(UINib(nibName: "BasicTableViewCell", bundle: nil), forCellReuseIdentifier: "BasicCell")
        mainTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        mainTableView.register(UINib(nibName: "HeaderSection", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        mainTableView.register(UINib(nibName: "PriceTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceCell")
        mainTableView.register(UINib(nibName: "TemperatureTableViewCell", bundle: nil), forCellReuseIdentifier: "TemperatureCell")
        mainTableView.register(UINib(nibName: "AirQualityTableViewCell", bundle: nil), forCellReuseIdentifier: "AirQualityCell")
        
        // 定位
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
    }
    
    // 處理最近的位置更新
    func locationManager(_ manger: CLLocationManager, didUpdateLocations location:[CLLocation]){
        locationManager.delegate = self
        
        let curLocation: CLLocation = location.last! // 取得最新的經緯度
        // print("經度緯度：\(curLocation.coordinate.longitude)緯度\(curLocation.coordinate.latitude)")
        
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
             *   subAdministrativeArea 台北市
             */
            // 回傳地理資訊
            if placemarks != nil && (placemarks?.count)! > 0{
                let placemark = (placemarks?[0])! as CLPlacemark
                //這邊拼湊轉回來的地址
                self.gpsLabel.text = placemark.locality
                print(placemark.administrativeArea as Any)
            }
        })
    }
    
    // 得到油價資訊
    func getOilprice(){
        if let oilUrl = URL(string: "http://127.0.0.1:8000/oils/"){
            let request = URLRequest(url: oilUrl)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {data, response, error in
                if let error = error{
                    print("\(error)")
                    return
                }
                
                guard let data = data else{
                    print("no data")
                    return
                }
                
                do {
                    let json = try
                        JSONSerialization.jsonObject(with: data)
                    if let toDic = json as? [String: String]{
                        self.priceArray = [toDic["92"]!, toDic["95"]!, toDic["98"]!, toDic["超級柴油"]!]
                        DispatchQueue.main.async {
                            self.mainTableView.reloadData()
                        }
                        print(self.priceArray)
                    }
                }catch{
                    print("\(error)")
                }
                
            })
            task.resume()
        }else{
            print("Invalid URL")
        }
    }
    
    // 警報資訊
    func getAlert(){
        let session = URLSession(configuration: .default)
        // 设置URL
        let url = "http://127.0.0.1:8000/alerts/"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // 设置要post的内容，字典格式
        let postData = ["city": "基隆市"]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        // 后面不解释了，和GET的注释一样
        let task = session.dataTask(with: request) {(data, response, error) in
            do {
                let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(r)
            } catch {
                print("AlertError")
                return
            }
        }
        task.resume()
    }
    
    // 刷新頁面
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing{
            getOilprice()
            refreshControl.endRefreshing()
        }
    }
    
    // TableView
    var tableViewSection = ["現在天氣", "空氣品質", "天氣", "節慶", "油價", "警報通知", "疾病"]
    var tableViewSection_under = [] as [String]
    var weatherRow = [" "]
    var hoildayRow = ["即將到來"]
    var diseaseRow = ["登革熱"]
    var holiday = "端午節"
    var disese = "中等"
    
    // 1.要有幾個section
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSection.count
    }
    
    // 2.每個section有幾個Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 3.Row的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch tableViewSection[indexPath.section] {
        case "現在天氣":
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemperatureCell", for: indexPath)as! TemperatureTableViewCell
            return cell
        case "空氣品質":
            let cell = tableView.dequeueReusableCell(withIdentifier: "AirQualityCell", for: indexPath)as! AirQualityTableViewCell
            return cell
        case "天氣":
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)as! WeatherTableViewCell
            cell.aqivalueLabel.text? = "100"
            cell.uvivalueLabel.text? = "50"
            
            return cell
        case "節慶":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)as! BasicTableViewCell
            cell.titleLabel.text? = hoildayRow[indexPath.row]
            cell.valueLabel.text? = holiday
            // cell.selectionStyle = .none
            return cell
        case "油價":
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath)as! PriceTableViewCell
            cell.unleadpriceLabel.text? = priceArray[0] + "元/公升"
            cell.superpriceLabel.text? = priceArray[1] + "元/公升"
            cell.supremepriceLabel.text? = priceArray[2] + "元/公升"
            cell.diesepriceLabel.text? = priceArray[3] + "元/公升"
            return cell
        case "警報通知":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)as! BasicTableViewCell
            return cell
        case "疾病":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)as! BasicTableViewCell
            cell.titleLabel.text? = diseaseRow[indexPath.row]
            cell.valueLabel.text? = disese
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // Row的高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableViewSection[indexPath.section] {
        case "現在天氣":
            return 100
        case "空氣品質":
            return 110
        case "天氣":
            return 158
        case "油價":
            return 250
        default:
            return 50
        }
        
    }
    
    // 設定header的View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")as! HeaderSection
        title.headerLabel.text? = tableViewSection[section]
        return title
    }
    
    // header的高
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
    }
    
    // Segue 頁面傳值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController: TableViewSectionset = segue.destination as! TableViewSectionset
        destViewController.sectionRow = tableViewSection
        destViewController.sectionInsertRow = tableViewSection_under
    }
    
    // TableView 取消section懸停效果
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainTableView! {
            let sectionHeaderHeight = CGFloat(45.0)//headerView的高度
            if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
                
                scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0);
                
            } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
                
                scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0);
            }
            
        }
    }

}






