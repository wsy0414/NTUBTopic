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
    @IBOutlet weak var pageControl: UIPageControl!
    
    var gasPrice: NSDictionary = ["unleaded": "", "super_": "", "supreme": "", "diesel": ""]
    var aqi: NSDictionary = ["AQI": "", "AQIStatus": "", "PM2.5": "", "PM2.5Status": ""]
    var weather: NSDictionary = ["tempNow": "", "uviH": "", "uviStatus": "", "tempMax": "", "tempMin": ""]
    var envir: NSDictionary = ["city": "", "warning": "", "date": "", "time": ""]
    var perWeather: NSDictionary=["city": "", "NowPoP": "", "NowWx": ""]
    var taipeiBike: NSDictionary = ["":""]
    var taipeiCloseBike: NSDictionary = ["StationName_zh":"", "AvailableRentBikes": "", "AvailableReturnBikes": ""]
    var index: Int = 0
    
    // TableView
    var tableViewSection = [""]
    var tableViewSectionUnder = [] as [String]

    // Presenter
    var gasPricePresenter: GasPricePresenter?
    var aqiPresenter: AqiPresenter?
    var weatherPresenter: WeatherPresenter?
    var environmentalWarningPresenter: EnvironmentalWarningPresenter?
    var preweatherPresenter: PreWeatherPresenter?
    var taipeiBikePresenter: TaipeiBikePresenter?
    var taipeiCloseBikePresenter: TaipeiCloseBikePresenter?
    
    var loadactivity = LoadActivity()
    
    
    var refreshControl: UIRefreshControl! // 宣告元件
    let userdefault = UserDefaults.standard
    
    let locationManager: CLLocationManager = CLLocationManager() // 設定定位管理器
    @IBOutlet weak var mainTableView: UITableView! // 主畫面的TableView
    @IBOutlet weak var gpsLabel: UILabel! // 地理資訊
    
    // button切換Section設定畫面
    @IBAction func toSectionset(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goSectionset", sender: self)
    }
    
    var location = CLLocationCoordinate2D(latitude: 0.0 , longitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        refreshControl = UIRefreshControl() // 初始化refresh元件
        mainTableView.addSubview(refreshControl)  // 加到tableview裡
        //tableViewSection = userdefault.value(forKey: "Section") as! [String]
        
        // 定位相關設定
        locationManager.delegate = self //設定服務代理
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 設定最佳精確度
        locationManager.distanceFilter = 10 // 距離多遠更新一次
        locationManager.requestAlwaysAuthorization() // 取得gps授權
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }else{
            print("位址失敗")
        }
        if  index == 0{
            location = locationManager.location!.coordinate

        }
        
        // setData()
        pageControl.currentPage = index
        registerCell()
        // print(userdefault.value(forKey: "Cities")) as! [String]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter()
    }
    
    func presenter(){
        gasPricePresenter = GasPricePresenter(delegate: self)
        gasPricePresenter?.getGasPrice(GetPrice: 1)
        
        aqiPresenter = AqiPresenter(delegate: self)
        aqiPresenter?.postAqi(Longitude: location.longitude, Latitude: location.latitude)
        
        weatherPresenter = WeatherPresenter(delegate: self)
        weatherPresenter?.postWeather(Longitude: location.longitude, Latitude: location.latitude)
        
        environmentalWarningPresenter = EnvironmentalWarningPresenter(delegate: self)
        environmentalWarningPresenter?.postEnvir(Longitude: location.longitude, Latitude: location.latitude)
        
        preweatherPresenter = PreWeatherPresenter(delegate: self)
        preweatherPresenter?.postPreWeather(Longitude: location.longitude, Latitude: location.latitude)
        
        taipeiBikePresenter = TaipeiBikePresenter(delegate: self)
        taipeiBikePresenter?.getAllBike(GetBike: "1")
        
        taipeiCloseBikePresenter = TaipeiCloseBikePresenter(delegate: self)
        taipeiCloseBikePresenter?.getCloseBike(Longitude: location.longitude, Latitude: location.latitude, type: "1")
        
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
            cell.weatherView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.weatherView.layer.shadowOpacity = 0.7
            cell.weatherView.layer.shadowRadius = 5
            cell.weatherView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor

            cell.aqiView.layer.cornerRadius = 10
            cell.aqiView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.aqiView.layer.shadowOpacity = 0.7
            cell.aqiView.layer.shadowRadius = 5
            cell.aqiView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
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
            case "對所有族群不健康":
                cell.aqiImg.image = UIImage(named: String("Red"))
                cell.aqiImg.isHidden = false
            case "對敏感族群不健康":
                cell.aqiImg.image = UIImage(named: String("Orange"))
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
            
            cell.selectionStyle = .none
            
            return cell
            
        case "現在天氣":
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherPicTableViewCell
            let tem = weather["tempMin"] as! String + "~" + (weather["tempMax"] as! String)
            cell.weatherPicView.layer.cornerRadius = 10
            cell.weatherPicView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.weatherPicView.layer.shadowOpacity = 0.7
            cell.weatherPicView.layer.shadowRadius = 5
            cell.weatherPicView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.temLbl.text? = tem
            cell.rainfallLbl.text? = perWeather["NowPoP"] as! String + "%"
            cell.wxLabel.text? = perWeather["NowWx"] as! String
            
            
            cell.selectionStyle = .none
            
            return cell
            
        case "油價":
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath)as! PriceTableViewCell
            cell.oilView.layer.cornerRadius = 10
            cell.oilView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.oilView.layer.shadowOpacity = 0.7
            cell.oilView.layer.shadowRadius = 5
            cell.oilView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.unleadpriceLabel.text = gasPrice["unleaded"] as! String + "元/公升"
            cell.superpriceLabel.text = gasPrice["super_"] as! String + "元/公升"
            cell.supremepriceLabel.text = gasPrice["supreme"] as! String + "元/公升"
            cell.diesepriceLabel.text = gasPrice["diesel"] as! String + "元/公升"
            cell.selectionStyle = .none
            return cell
            
        case "Bike":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)as! TaipeiBikeTableViewCell
            cell.cellbuttonDelegate = self
            cell.bikeView.layer.cornerRadius = 10
            cell.closeView.layer.cornerRadius = 10
            cell.bikeView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.bikeView.layer.shadowOpacity = 0.7
            cell.bikeView.layer.shadowRadius = 5
            cell.bikeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.closeStationLbl.text? = taipeiCloseBike["StationName_zh"] as! String
            cell.closeRentCnt.text? = taipeiCloseBike["AvailableRentBikes"] as! String
            cell.closeReturnCnt.text? = taipeiCloseBike["AvailableReturnBikes"] as! String
            cell.closeTitleLbl.layer.cornerRadius = 5
            cell.closeTitleLbl.backgroundColor = .gray
            cell.selectionStyle = .none
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
        case "Bike":
            return 100
        default:
            return 50
        }
    }
    
    // 設定header的View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")as! HeaderSection
        return title
    }
 
    // header的高
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0.001
    }
    
    /* Segue 頁面傳值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSectionSegue"{
            let destViewController: TableViewSectionset = segue.destination as! TableViewSectionset
            destViewController.sectionRow = tableViewSection
            destViewController.sectionInsertRow = tableViewSectionUnder
        }
    }
    */
    
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
        // mainTableView.register(UINib(nibName: "BasicTableViewCell", bundle: nil), forCellReuseIdentifier: "BasicCell")
        mainTableView.register(UINib(nibName: "HeaderSection", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        mainTableView.register(UINib(nibName: "PriceTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceCell")
        mainTableView.register(UINib(nibName: "TemperatureTableViewCell", bundle: nil), forCellReuseIdentifier: "TemperatureCell")
        mainTableView.register(UINib(nibName: "AirQualityTableViewCell", bundle: nil), forCellReuseIdentifier: "AirQualityCell")
        mainTableView.register(UINib(nibName: "WeatherPicTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        mainTableView.register(UINib(nibName: "TaipeiBikeTableViewCell", bundle: nil), forCellReuseIdentifier: "BikeCell")
    
    }
    
    func locationEncode(address: String){
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {
            (placemarks:[CLPlacemark]?, error:Error?) -> Void in
            
            if error != nil {
                print("错误：\(error!.localizedDescription))")
                return
            }
            if let p = placemarks?[0]{
                print("经度：\(p.location!.coordinate.longitude)")
                self.location.longitude = p.location!.coordinate.longitude
                print("纬度：\(p.location!.coordinate.latitude)")
                self.location.latitude = p.location!.coordinate.latitude
               
            } else {
                print("No placemarks!")
            }
        })
       
    }
    
    func locationManager(_ manger: CLLocationManager, didUpdateLocations location:[CLLocation]){
        locationManager.delegate = self
        var curLocation = CLLocation()
        let geoCoder = CLGeocoder()
        
        if index == 0{
            curLocation = location.last!
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
                    // self.city.append(placemark.locality!)
                   //  self.userdefault.set(self.city, forKey: "ChooseCities")
                }
            })
        }
        /*
        else{
            geoCoder.reverseGeocodeLocation(CLLocationCoordinate2D(latitude: , longitude: <#T##CLLocationDegrees#>), preferredLocale: nil , completionHandler: {(placemarks, error) -> Void in
                
                if error != nil { // 失敗回傳
                    return
                }
               
                // 回傳地理資訊
                if placemarks != nil && (placemarks?.count)! > 0{
                    let placemark = (placemarks?[0])! as CLPlacemark
                    //這邊拼湊轉回來的地址
                    if placemark.locality == nil{
                        self.gpsLabel.text = placemark.subAdministrativeArea
                        
                    }else{
                        self.gpsLabel.text = placemark.locality
                        
                    }
                }
            })
        }
        */
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
                        DispatchQueue.main.async {
                            self.gasPrice = datadic
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.mainTableView.reloadData()
                        }
                        
                    }catch let error{
                        print("Gas error")
                        print(error)
                    }
                case "PostAqi":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        DispatchQueue.main.async {
                            self.aqi = datadic
                            self.userdefault.set(self.aqi, forKey: "AQI")
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.mainTableView.reloadData()
                        }
                        
                    }catch let error{
                        print("Aqi error")
                        print(error)
                    }
                case "PostWeather":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        DispatchQueue.main.async {
                            self.weather = datadic
                            self.userdefault.set(self.weather, forKey: "Weather")
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.mainTableView.reloadData()
                        }
                        
                    }catch let error{
                        print(error)
                    }
                    
                case "PostEnvir":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        DispatchQueue.main.async {
                            self.envir = datadic
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.mainTableView.reloadData()
                        }
                        
                    }catch let error{
                        print(error)
                    }
                case "PostPreWeather":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        DispatchQueue.main.async {
                            self.perWeather = datadic
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.mainTableView.reloadData()
                        }
                        
                    }catch let error{
                        print(error)
                    }
                    
                case "GetBike":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        DispatchQueue.main.async {
                            self.taipeiBike = datadic
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.userdefault.set(self.taipeiBike, forKey: "TaipeiBike")
                            self.mainTableView.reloadData()
                        }
                    }catch let error{
                        print(error)
                    }
                    
                case "GetCloseBike":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        DispatchQueue.main.async {
                            self.taipeiCloseBike = datadic
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            print("close", self.taipeiCloseBike)
                            self.mainTableView.reloadData()
                            
                        }
                    }catch let error{
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
        }else if title == "toBikeMap"{
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TaipeiMainNav") {
                present(controller, animated: true, completion: nil)
            }
        }
        
        
    }
}


