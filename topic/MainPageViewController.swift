//
//  MainPageViewController.swift
//  topic
//
//  Created by 許維倫 on 2019/11/1.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit
import CoreLocation

class MainPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    let userdefault = UserDefaults.standard
    
    @IBAction func toSetting(_ sender: Any) {
        self.performSegue(withIdentifier: "toSetting", sender: self)
    }
    
    @IBAction func toSearch(_ sender: Any) {
        self.performSegue(withIdentifier: "toCityView", sender: self)
    }
    
    var sectionList = ["環境", "現在天氣", "油價", "Bike"]
    var underSectionList = [] as [String]
    var city = [String]()
    var location = CLLocationCoordinate2D(latitude: 120.0 , longitude: 0.0)
    
    // var loction = [["Longitude": 0, "Latitude": 0], ["Longitude": 121.5548065, "Latitude": 25.0287521]]
    // var longitude: Double = 0.0
    // var latitude: Double = 0.0
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int) -> ViewController? {
        
        if index < 0  || index >= city.count{
            return nil
        }else if index == 0{
            if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "main") as? ViewController {
                pageContentViewController.index = index
                pageContentViewController.tableViewSection = sectionList
                return pageContentViewController
            }
        }else{
            if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "main") as? ViewController {
                pageContentViewController.index = index
                pageContentViewController.tableViewSection = sectionList
                locationEncode(address: city[index])
                print(city[index])
                pageContentViewController.location = location
                return pageContentViewController
            }
        }
       
        return nil
    }
    
    func forward(index: Int) {
        if let nextViewController = contentViewController(at: index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        city = userdefault.value(forKey: "Cities") as! [String]
        // Set the data source to itself
        dataSource = self
        
        // Create the first walkthrough screen
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Segue 頁面傳值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSetting"{
            let destViewController: TableViewSectionset = segue.destination as! TableViewSectionset
            destViewController.sectionRow = sectionList
            destViewController.sectionInsertRow = underSectionList
        
        }
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
               print(self.location)
            } else {
                print("No placemarks!")
            }
        })
        
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
