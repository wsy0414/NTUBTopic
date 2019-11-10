//
//  TaipeiBikeMainViewController.swift
//  topic
//
//  Created by 許維倫 on 2019/10/30.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TaipeiBikeMainViewController: UIViewController, ViewControllerBaseDelegate, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBAction func toMain(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MainView") {
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var mapMainView: MKMapView!
    
    // let userdefaults = UserDefaults.standard
    
    var taipeiBikePresenter: TaipeiBikePresenter?
    
    var loadactivity = LoadActivity()
    var refreshControl: UIRefreshControl! // 宣告元件
    var taipeiBike = [NSDictionary]()
    var circle: MKOverlay?
    let locationManager: CLLocationManager = CLLocationManager() // 設定定位管理器
    let userdefault = UserDefaults.standard
    var bike = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapMainView.delegate = self
        refreshControl = UIRefreshControl() // 初始化refresh元件
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self //設定ViewController為代理人
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //準確度設定
        locationManager.activityType = .automotiveNavigation//移動的模式
        locationManager.startUpdatingLocation() //開始更新位置
        
        let latRange:CLLocationDegrees = 0.01
        let lonRange:CLLocationDegrees = 0.01
        let userLocation = locationManager.location?.coordinate
        let range:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latRange, longitudeDelta: lonRange)
        let appearRegion:MKCoordinateRegion = MKCoordinateRegion(center: userLocation!, span: range)
        mapMainView.setRegion(appearRegion, animated: true)
        mapMainView.showsCompass = true
        bike = userdefault.value(forKey: "BikeMap") as? String ?? ""
        
        switch bike {
        case "新北":
            taipeiBikePresenter = TaipeiBikePresenter(delegate: self)
            taipeiBikePresenter?.getAllBike(GetBike: "1", City: "NewTaipei")
        case "台北":
            taipeiBikePresenter = TaipeiBikePresenter(delegate: self)
            taipeiBikePresenter?.getAllBike(GetBike: "1", City: "Taipei")
        case "高雄":
            taipeiBikePresenter = TaipeiBikePresenter(delegate: self)
            taipeiBikePresenter?.getAllBike(GetBike: "1", City: "Kaohsiungu")
        case "新竹":
            taipeiBikePresenter = TaipeiBikePresenter(delegate: self)
            taipeiBikePresenter?.getAllBike(GetBike: "1", City: "Hsinchu")
        case "苗栗":
            taipeiBikePresenter = TaipeiBikePresenter(delegate: self)
            taipeiBikePresenter?.getAllBike(GetBike: "1", City: "MiaoliCounty")
        case "彰化":
            taipeiBikePresenter = TaipeiBikePresenter(delegate: self)
            taipeiBikePresenter?.getAllBike(GetBike: "1", City: "ChanghuaCounty")
        case "屏東":
            taipeiBikePresenter = TaipeiBikePresenter(delegate: self)
            taipeiBikePresenter?.getAllBike(GetBike: "1", City: "PingtungCounty")
        case "桃園":
            taipeiBikePresenter = TaipeiBikePresenter(delegate: self)
            taipeiBikePresenter?.getAllBike(GetBike: "1", City: "Taoyuan")
        case "台南":
            taipeiBikePresenter = TaipeiBikePresenter(delegate: self)
            taipeiBikePresenter?.getAllBike(GetBike: "1", City: "Tainan")
        case "台中":
            taipeiBikePresenter = TaipeiBikePresenter(delegate: self)
            taipeiBikePresenter?.getAllBike(GetBike: "1", City: "Taichung")
       
        default:
            break
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadactivity.showActivityIndicator(self.view)        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // setPin
    func setData(){
        var lon: Double
        var lat: Double
        var location:CLLocationCoordinate2D
        for a in taipeiBike{
            // let annotation = MKPointAnnotation()
            lon = a["Longitude"] as! Double
            lat = a["Latitude"] as! Double
            location = CLLocationCoordinate2DMake(lat, lon )
            let annotation = MyAnnotation(coordinate: location)
           
            annotation.title = (a["StationName_zh"] as! String)
            // annotation.subtitle = (a["AvailableRentBikes"] as! String)
            annotation.subtitle = "可借:\(a["AvailableRentBikes"] as! String) 可還: \(a["AvailableReturnBikes"] as! String)"
            mapMainView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView!, viewFor annotation: MKAnnotation!) -> MKAnnotationView! {
        let bikeImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        bikeImage.image = UIImage(named:"bikeLocation")
        
        if let temp = annotation as? MyAnnotation{
            var myView = mapMainView.dequeueReusableAnnotationView(withIdentifier: "MyPin")
            if myView == nil{
                myView = MKAnnotationView(annotation: temp, reuseIdentifier: "MyPin")
                myView?.image = UIImage(named: "bikeLocation")
                
                let button = UIButton(type: .detailDisclosure)
                button.addTarget(self, action: #selector(clickDetail), for: .touchUpInside)
                
                myView?.rightCalloutAccessoryView = button
                myView?.canShowCallout = true
            }else{
                myView?.annotation = annotation
            }
            return myView
        }else{
            return nil
        }
    }
    
    @objc func clickDetail(){
        let controller = UIAlertController(title: "選擇功能", message: "", preferredStyle: .actionSheet)
        let names = ["導航"]
        
        for name in names {
            let action = UIAlertAction(title: name, style: .default) { (action) in
                if action.title == "導航"{
                    let annotationLon = self.userdefault.value(forKey: "annotionLon") as! CLLocationDegrees
                    let annotationLat = self.userdefault.value(forKey: "annotionLat") as! CLLocationDegrees
                    let targetLoncation = CLLocationCoordinate2D(latitude: annotationLat, longitude: annotationLon)
                    let targetPlacemark = MKPlacemark(coordinate: targetLoncation)
                    let targetItem = MKMapItem(placemark: targetPlacemark)
                    let userMapItem = MKMapItem.forCurrentLocation()
                    let routes = [userMapItem,targetItem]
                    MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
                    print(targetLoncation)
                    print(annotationLon, annotationLat)
                    print(userMapItem)
                    print(targetPlacemark)
                    
                }
            }
            controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let latRange:CLLocationDegrees = 0.01
        let lonRange:CLLocationDegrees = 0.01
        let range:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latRange, longitudeDelta: lonRange)
        let appearRegion:MKCoordinateRegion = MKCoordinateRegion(center: view.annotation!.coordinate, span: range)
        userdefault.set(view.annotation?.coordinate.longitude, forKey: "annotionLon")
        userdefault.set(view.annotation?.coordinate.latitude, forKey: "annotionLat")
        
        mapMainView.setRegion(appearRegion, animated: true)
    }
   
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        // userdefault.removeObject(forKey: "annotionLon")
        // userdefault.removeObject(forKey: "annotionLat")
    }

    func PresenterCallBack(datadic: NSDictionary, success: Bool, type: String) {
        DispatchQueue.main.async {
            self.loadactivity.hideActivityIndicator(self.view)
        }
        
        if let result = datadic["result"] as? Int{
            if result == 1{
                switch type{
                case "GetBike":
                    do{
                        datadic.setValue(nil, forKey: "result")
                        // let jsonData = try JSONSerialization.data(withJSONObject: datadic, options: .prettyPrinted)
                        // self.gasPrice = try JSONDecoder().decode([GasPrice].self, from: jsonData)
                        
                        DispatchQueue.main.async {
                            self.taipeiBike = datadic["bikes"] as! [NSDictionary]
                            print(self.taipeiBike)
                            self.setData()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}



