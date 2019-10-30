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

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, ViewControllerBaseDelegate{
    
    var gasPrice: NSDictionary = ["unleaded": "", "super_": "", "supreme": "", "diesel": ""]
    var aqi: NSDictionary = ["AQI": "", "AQIStatus": "", "PM2.5": "", "PM2.5Status": ""]
    var weather: NSDictionary = ["tempNow": "", "uviH": "", "uviStatus": "", "tempMax": "", "tempMin": ""]
    var envir: NSDictionary = ["city": "", "warning": "", "date": "", "time": ""]
    var perWeather: NSDictionary=["city": "", "NowPoP": "", "NowWx": ""]
    
    
    // TableView
    var tableViewSection = ["環境", "現在天氣", "油價"]
    var tableViewSectionUnder = [] as [String]
    var hoildayRow = ["即將到來"]
    var diseaseRow = ["登革熱"]
    var holiday = "端午節"
    var disese = "中等"
    
    
    // Presenter
    var gasPricePresenter: GasPricePresenter?
    var aqiPresenter: AqiPresenter?
    var weatherPresenter: WeatherPresenter?
    var environmentalWarningPresenter: EnvironmentalWarningPresenter?
    var preweatherPresenter: PreWeatherPresenter?
    
    var loadactivity = LoadActivity()
   
    var userLongitude:Float = 121.528056
    var userLatitude:Float = 25.031331
 
    var refreshControl: UIRefreshControl! // 宣告元件
    let userdefault = UserDefaults.standard
    
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
        refreshControl = UIRefreshControl() // 初始化refresh元件
        mainTableView.addSubview(refreshControl)  // 加到tableview裡
        
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
        // setData()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gasPricePresenter = GasPricePresenter(delegate: self)
        gasPricePresenter?.getGasPrice(GetPrice: 1)
        
        aqiPresenter = AqiPresenter(delegate: self)
        aqiPresenter?.postAqi(Longitude: userLongitude, Latitude: userLatitude)
        
        weatherPresenter = WeatherPresenter(delegate: self)
        weatherPresenter?.postWeather(Longitude: userLongitude, Latitude: userLatitude)
        
        environmentalWarningPresenter = EnvironmentalWarningPresenter(delegate: self)
        environmentalWarningPresenter?.postEnvir(Longitude: userLongitude, Latitude: userLatitude)
        
        preweatherPresenter = PreWeatherPresenter(delegate: self)
        preweatherPresenter?.postPreWeather(Longitude: userLongitude, Latitude: userLatitude)
        
        self.loadactivity.showActivityIndicator(self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        let gasPrice = self.gasPrice
        
        let aqi = self.aqi
        let weather = self.weather
        
        switch tableViewSection[indexPath.section] {
        case "環境":
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemperatureCell", for: indexPath)as! TemperatureTableViewCell
            
            cell.weatherView.layer.cornerRadius = 10
            cell.aqiView.layer.cornerRadius = 10
        
            cell.temperatureValue.text? = weather["tempNow"] as! String
            cell.uviValue.text? = weather["uviH"] as! String
            cell.uviStatusLabel.text? = weather["uviStatus"] as! String
            
            cell.aqiValue.text? = aqi["AQI"] as! String
            cell.aqiStatus.text? = aqi["AQIStatus"] as! String
            cell.pmTwoValue.text? = aqi["PM2.5"] as! String
            cell.pmTwoStatus.text? = aqi["PM2.5Status"] as! String
            
            cell.cellbuttonDelegate = self
            
            switch weather["tempNow"] as! String{
            default:
                cell.temImage.image = UIImage(named: String("Green"))
            }
            
            switch weather["uviStatus"] as! String{
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
            
            switch aqi["AQIStatus"] as! String{
            case "良好":
                cell.aqiImg.image = UIImage(named: String("Green"))
                cell.aqiImg.isHidden = false
            case "普通":
                cell.aqiImg.image = UIImage(named: String("Yellow"))
                cell.aqiImg.isHidden = false
            default:
                cell.aqiImg.image = UIImage(named: String("Gray"))
                cell.aqiImg.isHidden = false
            }
            
            switch aqi["PM2.5Status"] as! String{
            case "良好":
                cell.pmTwoImg.image = UIImage(named: String("Green"))
                cell.pmTwoImg.isHidden = false
            case "普通":
                cell.pmTwoImg.image = UIImage(named: String("Yellow"))
                cell.pmTwoImg.isHidden = false
            case "對敏感族群不健康":
                cell.pmTwoImg.image = UIImage(named: String("Orange"))
                cell.pmTwoImg.isHidden = false
            case "不健康":
                cell.pmTwoImg.image = UIImage(named: String("Red"))
                cell.pmTwoImg.isHidden = false
            case "非常不健康":
                cell.pmTwoImg.image = UIImage(named: String("Purple"))
                cell.pmTwoImg.isHidden = false
            case "危險":
                cell.pmTwoImg.image = UIImage(named: String("Brown"))
                cell.pmTwoImg.isHidden = false
            default:
                cell.pmTwoImg.image = UIImage(named: String("Gray"))
                cell.pmTwoImg.isHidden = false
            }
            
            return cell
            
        case "現在天氣":
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherPicTableViewCell
            let tem = weather["tempMin"] as! String + "~" + (weather["tempMax"] as! String)
            cell.weatherPicView.layer.cornerRadius = 10
            
            cell.temLbl.text? = tem
            cell.rainfallLbl.text? = perWeather["NowPoP"] as! String + "%"
            cell.wxLabel.text? = perWeather["NowWx"] as! String
            
            return cell
            
        case "油價":
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath)as! PriceTableViewCell
            cell.oilView.layer.cornerRadius = 10
            
            cell.unleadpriceLabel.text = gasPrice["unleaded"] as! String + "元/公升"
            cell.superpriceLabel.text = gasPrice["super_"] as! String + "元/公升"
            cell.supremepriceLabel.text = gasPrice["supreme"] as! String + "元/公升"
            cell.diesepriceLabel.text = gasPrice["diesel"] as! String + "元/公升"
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
        case "環境":
            return 160
        case "現在天氣":
            return 280
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
            return 0.001
    }
    /*
    // 點選cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableViewSection[indexPath.section] {
        case "現在天氣":
            print("現在天氣")
        case "空氣品質":
            print("空氣")
        case "天氣":
            print("天氣")
        case "油價":
            print("油價")
        default:
           print("")
        }
    }
    */
    
    // Segue 頁面傳值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSectionSegue"{
            let destViewController: TableViewSectionset = segue.destination as! TableViewSectionset
            destViewController.sectionRow = tableViewSection
            destViewController.sectionInsertRow = tableViewSectionUnder
        }
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
    
    // 註冊Cell
    func registerCell(){
        mainTableView.register(UINib(nibName: "BasicTableViewCell", bundle: nil), forCellReuseIdentifier: "BasicCell")
        mainTableView.register(UINib(nibName: "HeaderSection", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        mainTableView.register(UINib(nibName: "PriceTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceCell")
        mainTableView.register(UINib(nibName: "TemperatureTableViewCell", bundle: nil), forCellReuseIdentifier: "TemperatureCell")
        mainTableView.register(UINib(nibName: "AirQualityTableViewCell", bundle: nil), forCellReuseIdentifier: "AirQualityCell")
        mainTableView.register(UINib(nibName: "WeatherPicTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        mainTableView.register(UINib(nibName: "WeatherCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionCell")        
    }
    
    /*
    func setData(){
        userDefaults.set(weatherArray, forKey: "weather")
        userDefaults.set(oilPriceArray, forKey: "oilPrice")
        userDefaults.set(aqiQualityArray, forKey: "aqiQuality")
    }
    */
    
    func locationManager(_ manger: CLLocationManager, didUpdateLocations location:[CLLocation]){
        locationManager.delegate = self
        
        let curLocation: CLLocation = location.last! // 取得最新的經緯度
        userLongitude = Float(curLocation.coordinate.longitude)
        userLatitude = Float(curLocation.coordinate.latitude)
        // print("經度緯度：\(curLocation.coordinate.longitude)緯度\(curLocation.coordinate.latitude)")
        // 經緯度轉換成地址
        let geoCoder = CLGeocoder()
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
    
    // 刷新頁面
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing{
            mainTableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    func PresenterCallBack(datadic: NSDictionary, success: Bool, type: String) {
        DispatchQueue.main.async {
            self.loadactivity.hideActivityIndicator(self.view)
        }
        
        if let result = datadic["result"] as? Int{
            if result == 1{
                switch type{
                case "GetGasPrice":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        // let jsonData = try JSONSerialization.data(withJSONObject: datadic, options: .prettyPrinted)
                        // self.gasPrice = try JSONDecoder().decode([GasPrice].self, from: jsonData)
                        
                        DispatchQueue.main.async {
                            self.gasPrice = datadic
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.mainTableView.reloadData()
                            print(self.gasPrice)
                        }
                        
                    }catch let error{
                        print("Gas error")
                        print(error)
                    }
                case "PostAqi":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        // let jsonData = try JSONSerialization.data(withJSONObject: datadic, options: .prettyPrinted)
                        // self.gasPrice = try JSONDecoder().decode([GasPrice].self, from: jsonData)
                        
                        DispatchQueue.main.async {
                            self.aqi = datadic
                            self.userdefault.set(self.aqi, forKey: "AQI")
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.mainTableView.reloadData()
                            print(self.aqi)
                        }
                        
                    }catch let error{
                        print("Aqi error")
                        print(error)
                    }
                case "PostWeather":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        // let jsonData = try JSONSerialization.data(withJSONObject: datadic, options: .prettyPrinted)
                        // self.gasPrice = try JSONDecoder().decode([GasPrice].self, from: jsonData)
                
                        DispatchQueue.main.async {
                            self.weather = datadic
                            self.userdefault.set(self.weather, forKey: "Weather")
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.mainTableView.reloadData()
                            print(self.weather)
                        }
                        
                    }catch let error{
                        print("Weather error")
                        print(error)
                    }
                
                case "PostEnvir":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        // let jsonData = try JSONSerialization.data(withJSONObject: datadic, options: .prettyPrinted)
                        // self.gasPrice = try JSONDecoder().decode([GasPrice].self, from: jsonData)
                        
                        DispatchQueue.main.async {
                            self.envir = datadic
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.mainTableView.reloadData()
                            print(self.envir)
                        }
                        
                    }catch let error{
                        print("Envir error")
                        print(error)
                    }
                case "PostPreWeather":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        // let jsonData = try JSONSerialization.data(withJSONObject: datadic, options: .prettyPrinted)
                        // self.gasPrice = try JSONDecoder().decode([GasPrice].self, from: jsonData)
                        
                        DispatchQueue.main.async {
                            self.perWeather = datadic
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.mainTableView.reloadData()
                            print(self.perWeather)
                        }
                        
                    }catch let error{
                        print("PreWeather error")
                        print(error)
                    }
                default:
                    break
                }
                
            }
        }
    
    }
    
    func PresenterCallBackError(error: NSError, type: String) {
        DispatchQueue.main.async {
            self.loadactivity.hideActivityIndicator(self.view)
        }
    }
}

// Btn in Cell
extension ViewController: CellButtonDelegate{
    func toDetail(title: String) {
        if title == "toWeather"{
            if let controller = storyboard?.instantiateViewController(withIdentifier: "WeatherNav") {
                present(controller, animated: true, completion: nil)
            }
        }else if title == "toAqi"{
            if let controller = storyboard?.instantiateViewController(withIdentifier: "AqiDetailNav") {
                present(controller, animated: true, completion: nil)
            }
        }
        
        
    }
}


