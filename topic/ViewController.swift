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
    var envir: NSDictionary = ["city": "", "warning": "", "date": "", "time": ""]
    var perWeather: NSDictionary=["city": "", "NowPoP": "", "NowWx": ""]
    
    var weather: Weather = Weather()
    
    var parkNTPC: ParkNTPC = ParkNTPC()
    // bikeMoudel
    var taipeiBike: TaipeiBike = TaipeiBike()
    var newtaipeiBike: NewTaipeiBike = NewTaipeiBike()
    var hsinchuBike : HsinchuBike = HsinchuBike()
    var miaoliBike : MiaoliBike = MiaoliBike()
    var changhuaBike : ChanghuaBike = ChanghuaBike()
    var pingtungBike : PingtungBike = PingtungBike()
    var taoyuanBike : TaoyuanBike = TaoyuanBike()
    var kaohsiungBike : KaohsiungBike = KaohsiungBike()
    var tainanBike : TainanBike = TainanBike()
    var taichungBike : TaichungBike = TaichungBike()
    
    var index: Int = 0
    // TableView
    var tableViewSection = [String]()
    // var tableViewSection =  ["環境", "現在天氣", "油價", "台北UBike"]
    var tableViewSectionUnder = [String]()
    
    
    // Presenter
    var gasPricePresenter: GasPricePresenter?
    var aqiPresenter: AqiPresenter?
    var weatherPresenter: WeatherPresenter?
    var environmentalWarningPresenter: EnvironmentalWarningPresenter?
    var preweatherPresenter: PreWeatherPresenter?
    var taipeiBikePresenter: TaipeiBikePresenter?
    var taipeiCloseBikePresenter: TaipeiCloseBikePresenter?
    var parkPresenter: ParkPresenter?
    
    var loadactivity = LoadActivity()
    var cityName: String = ""
    
    
    var refreshControl: UIRefreshControl! // 宣告元件
    let userdefault = UserDefaults.standard
    
    let locationManager: CLLocationManager = CLLocationManager() // 設定定位管理器
    @IBOutlet weak var mainTableView: UITableView! // 主畫面的TableView
    @IBOutlet weak var gpsLabel: UILabel! // 地理資訊
    
    // button切換Section設定畫面
    @IBAction func toSectionset(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goSectionset", sender: self)
    }
    
    var location = CLLocationCoordinate2D(latitude: 0.0 , longitude: 0.0) {
        didSet {
            presenter()
        }
    }
    
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
        
        if  locationManager.location != nil{
            location = locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0 , longitude: 0.0)
        }
        
        let pages = userdefault.value(forKey: "Cities") as? [String] ?? ["目前位置"]
        if pages.count == 1{
            pageControl.isEnabled = true
            pageControl.numberOfPages = 1
            pageControl.currentPage = 1
        }else{
            pageControl.numberOfPages = pages.count
            pageControl.currentPage = index
        }
        
        
        registerCell()
        locationEncode(address: cityName)
        
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
        
        taipeiCloseBikePresenter = TaipeiCloseBikePresenter(delegate: self)
        taipeiCloseBikePresenter?.getCloseBike(Longitude: location.longitude, Latitude: location.latitude, type: "1", city: "Taipei")
        
        if tableViewSection.contains("新北Bike"){
            taipeiCloseBikePresenter = TaipeiCloseBikePresenter(delegate: self)
            taipeiCloseBikePresenter?.getCloseBike(Longitude: location.longitude, Latitude: location.latitude, type: "1", city: "NewTaipei")
        }
        if tableViewSection.contains("新竹Bike"){
            taipeiCloseBikePresenter = TaipeiCloseBikePresenter(delegate: self)
            taipeiCloseBikePresenter?.getCloseBike(Longitude: location.longitude, Latitude: location.latitude, type: "1", city: "Hsinchu")
        }
        if tableViewSection.contains("苗栗Bike"){
            taipeiCloseBikePresenter = TaipeiCloseBikePresenter(delegate: self)
            taipeiCloseBikePresenter?.getCloseBike(Longitude: location.longitude, Latitude: location.latitude, type: "1", city: "MiaoliCounty")
        }
        if tableViewSection.contains("彰化Bike"){
            taipeiCloseBikePresenter = TaipeiCloseBikePresenter(delegate: self)
            taipeiCloseBikePresenter?.getCloseBike(Longitude: location.longitude, Latitude: location.latitude, type: "1", city: "ChanghuaCounty")
        }
        if tableViewSection.contains("屏東Bike"){
            taipeiCloseBikePresenter = TaipeiCloseBikePresenter(delegate: self)
            taipeiCloseBikePresenter?.getCloseBike(Longitude: location.longitude, Latitude: location.latitude, type: "1", city: "PingtungCounty")
        }
        if tableViewSection.contains("桃園Bike"){
            taipeiCloseBikePresenter = TaipeiCloseBikePresenter(delegate: self)
            taipeiCloseBikePresenter?.getCloseBike(Longitude: location.longitude, Latitude: location.latitude, type: "1", city: "Taoyuan")
        }
        if tableViewSection.contains("高雄Bike"){
            taipeiCloseBikePresenter = TaipeiCloseBikePresenter(delegate: self)
            taipeiCloseBikePresenter?.getCloseBike(Longitude: location.longitude, Latitude: location.latitude, type: "1", city: "Kaohsiung")
        }
        if tableViewSection.contains("台南Bike"){
            taipeiCloseBikePresenter = TaipeiCloseBikePresenter(delegate: self)
            taipeiCloseBikePresenter?.getCloseBike(Longitude: location.longitude, Latitude: location.latitude, type: "1", city: "Tainan")
        }
        
        if tableViewSection.contains("台中Bike"){
            taipeiCloseBikePresenter = TaipeiCloseBikePresenter(delegate: self)
            taipeiCloseBikePresenter?.getCloseBike(Longitude: location.longitude, Latitude: location.latitude, type: "1", city: "Taichung")
        }
        
        if tableViewSection.contains("新北市停車位"){
            parkPresenter = ParkPresenter(delegate: self)
            parkPresenter?.getClosePark(Longitude: location.longitude, Latitude: location.latitude, contain: "1", type: "0")
           
        }
        
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
            
            cell.temperatureValue.text? = weather.tempNow
            cell.uviValue.text? = weather.uviH ?? ""
            cell.uviStatusLabel.text? = weather.uviStatus ?? ""
            
            cell.aqiValue.text? = aqi["AQI"] as! String
            cell.aqiStatus.text? = aqi["AQIStatus"] as! String
            cell.pmTwoValue.text? = aqi["PM2.5"] as! String
            cell.pmTwoStatus.text? = aqi["PM2.5Status"] as! String
            
            cell.cellbuttonDelegate = self
            
            switch weather.tempNow {
            default:
                cell.temImage.image = UIImage(named: String("Green"))
            }
            
            switch weather.uviStatus {
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
            let tem = (weather.tempMin ?? "")  + "~" + (weather.tempMax ?? "")
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
            
        case "台北Bike":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)as! TaipeiBikeTableViewCell
            cell.cellbuttonDelegate = self
            cell.bikeView.layer.cornerRadius = 10
            cell.closeView.layer.cornerRadius = 10
            cell.bikeView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.bikeView.layer.shadowOpacity = 0.7
            cell.bikeView.layer.shadowRadius = 5
            cell.bikeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.cityName.text = "台北Bike"
            cell.closeStationLbl.text? = taipeiBike.StationName_zh ?? ""
            cell.closeRentCnt.text? = taipeiBike.AvailableRentBikes ?? ""
            cell.closeReturnCnt.text? = taipeiBike.AvailableReturnBikes ?? ""
            cell.closeTitleLbl.text? = "距離" + (taipeiBike.haversine ?? "") + "M"
            cell.closeTitleLbl.layer.cornerRadius = 5
            cell.closeTitleLbl.backgroundColor = .gray
            cell.selectionStyle = .none
            return cell
            
        case "新北Bike":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)as! TaipeiBikeTableViewCell
            cell.cellbuttonDelegate = self
            cell.bikeView.layer.cornerRadius = 10
            cell.closeView.layer.cornerRadius = 10
            cell.bikeView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.bikeView.layer.shadowOpacity = 0.7
            cell.bikeView.layer.shadowRadius = 5
            cell.bikeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.cityName.text = "新北Bike"
            cell.closeStationLbl.text? = newtaipeiBike.StationName_zh ?? ""
            cell.closeRentCnt.text? = newtaipeiBike.AvailableRentBikes ?? ""
            cell.closeReturnCnt.text? = newtaipeiBike.AvailableReturnBikes ?? ""
            cell.closeTitleLbl.text? = "距離" + (newtaipeiBike.haversine ?? "") + "M"
            cell.closeTitleLbl.layer.cornerRadius = 5
            cell.closeTitleLbl.backgroundColor = .gray
            cell.selectionStyle = .none
            return cell
            
        case "新竹Bike":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)as! TaipeiBikeTableViewCell
            cell.cellbuttonDelegate = self
            cell.bikeView.layer.cornerRadius = 10
            cell.closeView.layer.cornerRadius = 10
            cell.bikeView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.bikeView.layer.shadowOpacity = 0.7
            cell.bikeView.layer.shadowRadius = 5
            cell.bikeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.cityName.text = "新竹Bike"
            cell.closeStationLbl.text? = hsinchuBike.StationName_zh ?? ""
            cell.closeRentCnt.text? = hsinchuBike.AvailableRentBikes ?? ""
            cell.closeReturnCnt.text? = hsinchuBike.AvailableReturnBikes ?? ""
            cell.closeTitleLbl.text? = "距離" + (hsinchuBike.haversine ?? "") + "M"
            cell.closeTitleLbl.layer.cornerRadius = 5
            cell.closeTitleLbl.backgroundColor = .gray
            cell.selectionStyle = .none
            return cell
        case "苗栗Bike":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)as! TaipeiBikeTableViewCell
            cell.cellbuttonDelegate = self
            cell.bikeView.layer.cornerRadius = 10
            cell.closeView.layer.cornerRadius = 10
            cell.bikeView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.bikeView.layer.shadowOpacity = 0.7
            cell.bikeView.layer.shadowRadius = 5
            cell.bikeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.cityName.text = "苗栗Bike"
            cell.closeStationLbl.text? = miaoliBike.StationName_zh ?? ""
            cell.closeRentCnt.text? = miaoliBike.AvailableRentBikes ?? ""
            cell.closeReturnCnt.text? = miaoliBike.AvailableReturnBikes ?? ""
            cell.closeTitleLbl.text? = "距離" + (miaoliBike.haversine ?? "") + "M"
            cell.closeTitleLbl.layer.cornerRadius = 5
            cell.closeTitleLbl.backgroundColor = .gray
            cell.selectionStyle = .none
            return cell
        case "彰化Bike":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)as! TaipeiBikeTableViewCell
            cell.cellbuttonDelegate = self
            cell.bikeView.layer.cornerRadius = 10
            cell.closeView.layer.cornerRadius = 10
            cell.bikeView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.bikeView.layer.shadowOpacity = 0.7
            cell.bikeView.layer.shadowRadius = 5
            cell.bikeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.cityName.text = "彰化Bike"
            cell.closeStationLbl.text? = changhuaBike.StationName_zh ?? ""
            cell.closeRentCnt.text? = changhuaBike.AvailableRentBikes ?? ""
            cell.closeReturnCnt.text? = changhuaBike.AvailableReturnBikes ?? ""
            cell.closeTitleLbl.text? = "距離" + (changhuaBike.haversine ?? "") + "M"
            cell.closeTitleLbl.layer.cornerRadius = 5
            cell.closeTitleLbl.backgroundColor = .gray
            cell.selectionStyle = .none
            return cell
        case "屏東Bike":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)as! TaipeiBikeTableViewCell
            cell.cellbuttonDelegate = self
            cell.bikeView.layer.cornerRadius = 10
            cell.closeView.layer.cornerRadius = 10
            cell.bikeView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.bikeView.layer.shadowOpacity = 0.7
            cell.bikeView.layer.shadowRadius = 5
            cell.bikeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
             
            cell.cityName.text = "屏東Bike"
            cell.closeStationLbl.text? = pingtungBike.StationName_zh ?? ""
            cell.closeRentCnt.text? = pingtungBike.AvailableRentBikes ?? ""
            cell.closeReturnCnt.text? = pingtungBike.AvailableReturnBikes ?? ""
            cell.closeTitleLbl.text? = "距離" + (pingtungBike.haversine ?? "") + "M"
            cell.closeTitleLbl.layer.cornerRadius = 5
            cell.closeTitleLbl.backgroundColor = .gray
            cell.selectionStyle = .none
            return cell
        case "桃園Bike":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)as! TaipeiBikeTableViewCell
            cell.cellbuttonDelegate = self
            cell.bikeView.layer.cornerRadius = 10
            cell.closeView.layer.cornerRadius = 10
            cell.bikeView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.bikeView.layer.shadowOpacity = 0.7
            cell.bikeView.layer.shadowRadius = 5
            cell.bikeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.cityName.text = "桃園Bike"
            cell.closeStationLbl.text? = taoyuanBike.StationName_zh ?? ""
            cell.closeRentCnt.text? = taoyuanBike.AvailableRentBikes ?? ""
            cell.closeReturnCnt.text? = taoyuanBike.AvailableReturnBikes ?? ""
            cell.closeTitleLbl.text? = "距離" + (taoyuanBike.haversine ?? "") + "M"
            cell.closeTitleLbl.layer.cornerRadius = 5
            cell.closeTitleLbl.backgroundColor = .gray
            cell.selectionStyle = .none
            return cell
        case "高雄Bike":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)as! TaipeiBikeTableViewCell
            cell.cellbuttonDelegate = self
            cell.bikeView.layer.cornerRadius = 10
            cell.closeView.layer.cornerRadius = 10
            cell.bikeView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.bikeView.layer.shadowOpacity = 0.7
            cell.bikeView.layer.shadowRadius = 5
            cell.bikeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.cityName.text = "高雄Bike"
            cell.closeStationLbl.text? = kaohsiungBike.StationName_zh ?? ""
            cell.closeRentCnt.text? = kaohsiungBike.AvailableRentBikes ?? ""
            cell.closeReturnCnt.text? = kaohsiungBike.AvailableReturnBikes ?? ""
            cell.closeTitleLbl.text? = "距離" + (kaohsiungBike.haversine ?? "") + "M"
            cell.closeTitleLbl.layer.cornerRadius = 5
            cell.closeTitleLbl.backgroundColor = .gray
            cell.selectionStyle = .none
            return cell
        case "台南Bike":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)as! TaipeiBikeTableViewCell
            cell.cellbuttonDelegate = self
            cell.bikeView.layer.cornerRadius = 10
            cell.closeView.layer.cornerRadius = 10
            cell.bikeView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.bikeView.layer.shadowOpacity = 0.7
            cell.bikeView.layer.shadowRadius = 5
            cell.bikeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.cityName.text = "台南Bike"
            cell.closeStationLbl.text? = tainanBike.StationName_zh ?? ""
            cell.closeRentCnt.text? = tainanBike.AvailableRentBikes ?? ""
            cell.closeReturnCnt.text? = tainanBike.AvailableReturnBikes ?? ""
            cell.closeTitleLbl.text? = "距離" + (tainanBike.haversine ?? "") + "M"
            cell.closeTitleLbl.layer.cornerRadius = 5
            cell.closeTitleLbl.backgroundColor = .gray
            cell.selectionStyle = .none
            return cell
        case "台中Bike":
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)as! TaipeiBikeTableViewCell
            cell.cellbuttonDelegate = self
            cell.bikeView.layer.cornerRadius = 10
            cell.closeView.layer.cornerRadius = 10
            cell.bikeView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.bikeView.layer.shadowOpacity = 0.7
            cell.bikeView.layer.shadowRadius = 5
            cell.bikeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            
            cell.cityName.text = "台中Bike"
            cell.closeStationLbl.text? = taichungBike.StationName_zh ?? ""
            cell.closeRentCnt.text? = taichungBike.AvailableRentBikes ?? ""
            cell.closeReturnCnt.text? = taichungBike.AvailableReturnBikes ?? ""
            cell.closeTitleLbl.text? = "距離" + (taichungBike.haversine ?? "") + "M"
            cell.closeTitleLbl.layer.cornerRadius = 5
            cell.closeTitleLbl.backgroundColor = .gray
            cell.selectionStyle = .none
            
            return cell
        case "新北市停車位":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell", for: indexPath) as! ParkNTPCTableViewCell
            cell.status.text? = parkNTPC.ParkStatusZh ?? ""
            cell.name.text? = parkNTPC.NAME ?? ""
            
            if parkNTPC.MEMO != nil{
                cell.memo.text? = parkNTPC.MEMO ?? ""
            }else{
                cell.memo.text = "無"
            }
            
            cell.parkView.layer.cornerRadius = 10
            cell.parkView.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.parkView.layer.shadowOpacity = 0.7
            cell.parkView.layer.shadowRadius = 5
            cell.parkView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
    
            cell.parkinView.layer.cornerRadius = 10
            cell.payCash.text? = parkNTPC.PAYCASH ?? "" 
            cell.haversine.text? = "距離" + (parkNTPC.Haversine ?? "") + "M"
            cell.haversine.layer.cornerRadius = 5
            cell.haversine.backgroundColor = .gray
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
        case "台北Bike":
            return 100
        case "新北Bike", "新竹Bike", "苗栗Bike", "彰化Bike", "屏東Bike", "桃園Bike", "高雄Bike", "台南Bike", "台中Bike":
            return 100
        case "新北市停車位":
            return 120
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
        mainTableView.register(UINib(nibName: "ParkNTPCTableViewCell", bundle: nil), forCellReuseIdentifier: "ParkCell")
    
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
                self.location = p.location?.coordinate ?? CLLocationCoordinate2DMake(0.0,
                                                                                     0.0)
            } else {
                print("No placemarks!")
            }
        })
       
    }
    
    // 點擊事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch tableViewSection[indexPath.section] {
        case "台北Bike":
            userdefault.set("台北", forKey: "BikeMap")
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TaipeiMainNav") {
                present(controller, animated: true, completion: nil)
            }
        case "新北Bike":
            userdefault.set("新北", forKey: "BikeMap")
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TaipeiMainNav") {
                present(controller, animated: true, completion: nil)
            }
        case "高雄Bike":
            userdefault.set("高雄", forKey: "BikeMap")
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TaipeiMainNav") {
                present(controller, animated: true, completion: nil)
            }
        case "新竹Bike":
            userdefault.set("新竹", forKey: "BikeMap")
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TaipeiMainNav") {
                present(controller, animated: true, completion: nil)
            }
        case "苗栗Bike":
            userdefault.set("苗栗", forKey: "BikeMap")
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TaipeiMainNav") {
                present(controller, animated: true, completion: nil)
            }
        case "彰化Bike":
            userdefault.set("彰化", forKey: "BikeMap")
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TaipeiMainNav") {
                present(controller, animated: true, completion: nil)
            }
        case "屏東Bike":
            userdefault.set("屏東", forKey: "BikeMap")
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TaipeiMainNav") {
                present(controller, animated: true, completion: nil)
            }
        case "台南Bike":
            userdefault.set("台南", forKey: "BikeMap")
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TaipeiMainNav") {
                present(controller, animated: true, completion: nil)
            }
        case "台中Bike":
            userdefault.set("台中", forKey: "BikeMap")
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TaipeiMainNav") {
                present(controller, animated: true, completion: nil)
            }
        case "桃園Bike":
            userdefault.set("桃園", forKey: "BikeMap")
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TaipeiMainNav") {
                present(controller, animated: true, completion: nil)
            }
        case "新北市停車位":
            userdefault.set("新北市車位", forKey: "BikeMap")
            if let controller = storyboard?.instantiateViewController(withIdentifier: "parkNTPCNav") {
                present(controller, animated: true, completion: nil)
            }
        default:
            break
        }
        
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
                }
            })
        }else{
            let cities = userdefault.value(forKey: "Cities") as? [String] ?? ["目前位置"]
            
//             let city = String(cities[index].suffix(3))
 //           gpsLabel.text = city
        }
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
                            self.weather = self.covertToModel(jsonDic: datadic,
                                                              item: Weather())
                            
                            self.userdefault.set(datadic, forKey: "Weather")
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
                            self.taipeiBike = self.covertToModel(jsonDic: datadic,
                                                                 item: TaipeiBike())
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            self.mainTableView.reloadData()
                            
                        }
                    }catch let error{
                        print(error)
                    }
                case "GetNewTaipeiBike":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        DispatchQueue.main.async {
                            self.newtaipeiBike = self.covertToModel(jsonDic: datadic,
                                                                 item: NewTaipeiBike())
                            self.mainTableView.delegate = self
                            self.mainTableView.dataSource = self
                            print("newTai")
                            self.mainTableView.reloadData()
                            
                        }
                    }catch let error{
                        print(error)
                    }
                case "GetHsinchuBike":
                do{
                    datadic.setValue(nil, forKey: "result")
                    DispatchQueue.main.async {
                        self.hsinchuBike = self.covertToModel(jsonDic: datadic,
                                                             item: HsinchuBike())
                        self.mainTableView.delegate = self
                        self.mainTableView.dataSource = self
                        print("hsinchu")
                        self.mainTableView.reloadData()
                        
                    }
                }catch let error{
                    print(error)
                }
                    
                case "GetMiaoliBike":
                do{
                    datadic.setValue(nil, forKey: "result")
                    DispatchQueue.main.async {
                        self.miaoliBike = self.covertToModel(jsonDic: datadic,
                                                             item: MiaoliBike())
                        self.mainTableView.delegate = self
                        self.mainTableView.dataSource = self
                        print("Miaoli")
                        self.mainTableView.reloadData()
                        
                    }
                }catch let error{
                    print(error)
                }
                case "GetChanghuaBike":
                do{
                    datadic.setValue(nil, forKey: "result")
                    DispatchQueue.main.async {
                        self.changhuaBike = self.covertToModel(jsonDic: datadic,
                                                             item: ChanghuaBike())
                        self.mainTableView.delegate = self
                        self.mainTableView.dataSource = self
                        print("Changhua")
                        self.mainTableView.reloadData()
                        
                    }
                }catch let error{
                    print(error)
                }
                case "GetPingtungBike":
                do{
                    datadic.setValue(nil, forKey: "result")
                    DispatchQueue.main.async {
                        self.pingtungBike = self.covertToModel(jsonDic: datadic,
                                                             item: PingtungBike())
                        self.mainTableView.delegate = self
                        self.mainTableView.dataSource = self
                        print("Pingtung")
                        self.mainTableView.reloadData()
                        
                    }
                }catch let error{
                    print(error)
                }
                case "GetKaohsiungBike":
                do{
                    datadic.setValue(nil, forKey: "result")
                    DispatchQueue.main.async {
                        self.kaohsiungBike = self.covertToModel(jsonDic: datadic,
                                                             item: KaohsiungBike())
                        self.mainTableView.delegate = self
                        self.mainTableView.dataSource = self
                        print("kaohsiung")
                        self.mainTableView.reloadData()
                        
                    }
                }catch let error{
                    print(error)
                }
                case "GetTainanBike":
                do{
                    datadic.setValue(nil, forKey: "result")
                    DispatchQueue.main.async {
                        self.tainanBike = self.covertToModel(jsonDic: datadic,
                                                             item: TainanBike())
                        self.mainTableView.delegate = self
                        self.mainTableView.dataSource = self
                        print("tainan")
                        self.mainTableView.reloadData()
                        
                    }
                }catch let error{
                    print(error)
                }
            
                case "GetTaichungBike":
                do{
                    datadic.setValue(nil, forKey: "result")
                    DispatchQueue.main.async {
                        self.taichungBike = self.covertToModel(jsonDic: datadic,
                                                             item: TaichungBike())
                        self.mainTableView.delegate = self
                        self.mainTableView.dataSource = self
                        print("taichung")
                        self.mainTableView.reloadData()
                        
                    }
                }catch let error{
                    print(error)
                }
                case "GetTaoyuanBike":
                do{
                    datadic.setValue(nil, forKey: "result")
                    DispatchQueue.main.async {
                        self.taoyuanBike = self.covertToModel(jsonDic: datadic,
                                                             item: TaoyuanBike())
                        self.mainTableView.delegate = self
                        self.mainTableView.dataSource = self
                        print("taichung")
                        self.mainTableView.reloadData()
                        
                    }
                }catch let error{
                    print(error)
                }
                    
                case "GetClosePark":
                do{
                    datadic.setValue(nil, forKey: "result")
                    DispatchQueue.main.async {
                        var jsonArr = Array<Any>()
                        if (datadic["parks"] as? Array<Any>) != nil{
                            jsonArr = datadic["parks"] as! Array<Any>
                            self.parkNTPC = self.covertToModel(jsonDic: (jsonArr[0] as? NSDictionary ?? ["": ""]) ,
                                                               item: ParkNTPC())
                        }
                        
                        self.mainTableView.delegate = self
                        self.mainTableView.dataSource = self
                        print(jsonArr)
                        
                        print(datadic)
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
    
    func covertToModel<T: Decodable>(jsonDic: NSDictionary, item: T) -> T {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDic, options: [])
            let decoder: JSONDecoder = JSONDecoder()
            let jsonModel = try decoder.decode(T.self, from: data)
            return jsonModel
        } catch {
            return item
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
            
        }
    }
    
  

}



