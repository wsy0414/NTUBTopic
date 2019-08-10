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
    var priceArray: [String] = ["", "", "", ""] // 油價初始值
    var userLongitude:Float = 121.528056
    var userLatitude:Float = 25.031331
    var qualityArray: [String] = ["", "", "", ""]
    var weatherArray: [String] = ["", "", ""]
 
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
        
    
        // 初始化refresh元件
        refreshControl = UIRefreshControl()
        mainTableView.addSubview(refreshControl)  // 加到tableview裡
        
        // 註冊自定義tableViewCell
        mainTableView.register(UINib(nibName: "BasicTableViewCell", bundle: nil), forCellReuseIdentifier: "BasicCell")

        mainTableView.register(UINib(nibName: "HeaderSection", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        mainTableView.register(UINib(nibName: "PriceTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceCell")
        mainTableView.register(UINib(nibName: "TemperatureTableViewCell", bundle: nil), forCellReuseIdentifier: "TemperatureCell")
        mainTableView.register(UINib(nibName: "AirQualityTableViewCell", bundle: nil), forCellReuseIdentifier: "AirQualityCell")
        
        // 定位相關設定
        locationManager.delegate = self //設定服務代理
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 設定最佳精確度
        locationManager.distanceFilter = 100 // 距離多遠更新一次
        locationManager.requestAlwaysAuthorization() // 取得gps授權
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }else{
            print("位址失敗")
        }
        postWeather()
        postAqi()
        getOilprice()
    }
    
    // 處理最近的位置更新
    func locationManager(_ manger: CLLocationManager, didUpdateLocations location:[CLLocation]){
        locationManager.delegate = self
        
        let curLocation: CLLocation = location.last! // 取得最新的經緯度
        userLongitude = Float(curLocation.coordinate.longitude)
        userLatitude = Float(curLocation.coordinate.latitude)
        // print("經度緯度：\(curLocation.coordinate.longitude)緯度\(curLocation.coordinate.latitude)")
        // 經緯度轉換成地址
        let geoCoder = CLGeocoder() //
        geoCoder.reverseGeocodeLocation(curLocation, preferredLocale: nil , completionHandler: {(placemarks, error) -> Void in
            
            if error != nil { // 失敗回傳
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
            }
        })
    }
    
    // 得到油價資訊 http://127.0.0.1:8000/oils/
    func getOilprice(){
        if let oilUrl = URL(string: "https://topic-ntub.herokuapp.com/oils/"){
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
                    let json =
                        try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    self.priceArray = [json["92"]!, json["95"]!, json["98"]!, json["超級柴油"]!] as! [String]
                    print("oilPrice")
                }catch{
                    print("\(error)")
                }
                
            })
            task.resume()
        }else{
            print("Invalid URL")
        }
    }
    // post 天氣資訊
    func postWeather(){
        let session = URLSession(configuration: .default)
        // 设置URL
        let url = "https://topic-ntub.herokuapp.com/weather/"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // 设置要post的内容，
        let postData = ["Longitude":userLongitude,"Latitude":userLatitude]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        
        // 處理資料
        let task = session.dataTask(with: request) {(data, response, error) in
            guard let data = data else{
                print("none")
                print(postString)
                print(type(of: postString))
                return
            }
            do {
                let json =
                    try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                self.weatherArray = [json["temp_now"]!, json["UVI_H"]!, json["uvi_status"]!, json["Wind_dir"]!, json["Wind_speed"]!, json["humd"]!, json["RainFall"]!,json["temp_max"]!, json["temp_min"]!] as! [String]
                print(self.weatherArray)
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            } catch {
                print("无法连接到服务器")
                return
            }
        }
        task.resume()
    }
    
    // 空氣品質
    func postAqi(){
        let session = URLSession(configuration: .default)
        // 设置URL
        let url = "https://topic-ntub.herokuapp.com/aqi/"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // 设置要post的内容，
        let postData = ["Longitude":userLongitude,"Latitude":userLatitude]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        
        // 處理資料
        let task = session.dataTask(with: request) {(data, response, error) in
            // 沒資料回傳
            guard let data = data else{
                return
            }
            do {
                let json =
                    try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(json)
                self.qualityArray=[json["AQI"]!, json["PM2.5"]!, json["Status"]!, json["PM2.5_Status"]!, json["PM10"]!, json["Co"]!, json["So2"]!,json["O3"]!, json["PM2.5_avg"]!, json["PM10_avg"]!, json["County"]!, json["SiteName"]!, json["Time"]!] as! [String]
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
                print("qualityArray")
            } catch {
                print("无法连接到服务器")
                return
            }
        }
        task.resume()
    }
    
    // 警報資訊
    func getAlert(){
        let session = URLSession(configuration: .default)
        
        let url = "http://127.0.0.1:8000/alerts/"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let postData = ["city": "基隆市"]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        
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
            postAqi()
            mainTableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    // TableView
    var tableViewSection = ["現在天氣", "空氣品質", "節慶", "油價", "警報通知", "疾病"]
    var tableViewSection_under = [] as [String]
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
            cell.temperatureValue.text? = weatherArray[0]
            cell.uviValue.text? = weatherArray[1]
            cell.uviStatusLabel.text? = weatherArray[2]
            
            switch weatherArray[0]{
            default:
                cell.temImage.image = UIImage(named: String("Green"))
            }
            
            switch weatherArray[2]{
            case "低量級":
                cell.uviImage.image = UIImage(named: String("Green"))
            case "中量級":
                cell.uviImage.image = UIImage(named: String("Yellow"))
            case "高量級":
                cell.uviImage.image = UIImage(named: String("Red"))
            case "過量級":
                cell.uviImage.image = UIImage(named: String("Purple"))
            case "危險級":
                cell.uviImage.image = UIImage(named: String("Brown"))
            default:
                cell.uviImage.image = UIImage(named: String("Gray"))
            }
            return cell
            
        case "空氣品質":
            let cell = tableView.dequeueReusableCell(withIdentifier: "AirQualityCell", for: indexPath)as! AirQualityTableViewCell
            cell.aqivalueLabel.text? = qualityArray[0]
            cell.pmtwoLabel.text? = qualityArray[1]
            cell.aqiStatusLb.text? = qualityArray[2]
            cell.pmtwoStatueLb.text? = qualityArray[3]
            // aqi
            switch qualityArray[2]{
            case "良好":
                cell.aqiImage.image = UIImage(named: String("Green"))
                cell.aqiImage.isHidden = false
            case "普通":
                cell.aqiImage.image = UIImage(named: String("Yellow"))
                cell.aqiImage.isHidden = false
            default:
                cell.aqiImage.image = UIImage(named: String("Gray"))
                cell.aqiImage.isHidden = false
            }
           
            // pmtwo
            switch qualityArray[3]{
            case "良好":
                cell.pmtwoImage.image = UIImage(named: String("Green"))
                cell.pmtwoImage.isHidden = false
            case "普通":
                cell.pmtwoImage.image = UIImage(named: String("Yellow"))
                cell.pmtwoImage.isHidden = false
            case "對敏感族群不健康":
                cell.pmtwoImage.image = UIImage(named: String("Orange"))
                cell.pmtwoImage.isHidden = false
            case "不健康":
                cell.pmtwoImage.image = UIImage(named: String("Red"))
                cell.pmtwoImage.isHidden = false
            case "非常不健康":
                cell.pmtwoImage.image = UIImage(named: String("Purple"))
                cell.pmtwoImage.isHidden = false
            case "危險":
                cell.pmtwoImage.image = UIImage(named: String("Brown"))
                cell.pmtwoImage.isHidden = false
            default:
                cell.pmtwoImage.image = UIImage(named: String("Gray"))
                 cell.pmtwoImage.isHidden = false
            }

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
            return 110
        case "空氣品質":
            return 130
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
    
    // 點選cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableViewSection[indexPath.section] {
        case "現在天氣":
            if let controller = storyboard?.instantiateViewController(withIdentifier: "WeatherTViewController") as? WeatherTViewController{
                controller.weatherArray = weatherArray
                present(controller, animated: true, completion: nil)
            }
           
        case "空氣品質":
            if let controller = storyboard?.instantiateViewController(withIdentifier: "AqiDetailTViewController") as? AqiDetailTViewController {
                controller.qualityArray = qualityArray
                present(controller, animated: true, completion: nil)
            }
        case "天氣":
            print("天氣")
        case "油價":
            print("油價")
        default:
           print("")
        }
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






