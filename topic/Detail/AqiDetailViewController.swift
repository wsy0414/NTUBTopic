//
//  AqiDetailViewController.swift
//  topic
//
//  Created by 許維倫 on 2019/10/19.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit

class AqiDetailViewController: UIViewController {

    @IBOutlet weak var aqiViewA: UIView!
    @IBOutlet weak var aqiViewB: UIView!
    @IBOutlet weak var aqiViewC: UIView!
    
    @IBOutlet weak var aqiValueLbl: UILabel!
    @IBOutlet weak var aqiSLbl: UILabel!
    @IBOutlet weak var aqiPicImg: UIImageView!
    
    @IBOutlet weak var pmTValueLbl: UILabel!
    @IBOutlet weak var pmTwoSLbl: UILabel!
    @IBOutlet weak var pmTwoPicImg: UIImageView!
    
    @IBOutlet weak var pmTenValLbl: UILabel!
    @IBOutlet weak var coValueLbl: UILabel!
    @IBOutlet weak var soValueLbl: UILabel!
    @IBOutlet weak var othreValueLbl: UILabel!
    
    @IBOutlet weak var pmTenAvgLbl: UILabel!
    @IBOutlet weak var pmTwoAvgLbl: UILabel!
    
    @IBOutlet weak var countyLbl: UILabel!
    @IBOutlet weak var siteLbl: UILabel!
    
    let userdefault = UserDefaults.standard
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setView()
        
        // Do any additional setup after loading the view.
    }
    
    func setView(){
        aqiViewA.layer.cornerRadius = 10
        aqiViewB.layer.cornerRadius = 10
        aqiViewC.layer.cornerRadius = 10
    }
    
    func setData(){
        var aqiDetail = userdefault.dictionary(forKey: "AQI") as! [String: String]
        
        aqiValueLbl.text? = aqiDetail["AQI"]!
        aqiSLbl.text? = aqiDetail["AQIStatus"]!
        
        // aqi
        if aqiDetail["AQIStatus"]! == "良好"{
            aqiPicImg.image = UIImage(named: String("Green"))
            aqiPicImg.isHidden = false
        }else if aqiDetail["AQIStatus"]! == "普通"{
            aqiPicImg.image = UIImage(named: String("Yellow"))
            aqiPicImg.isHidden = false
        }else{
            aqiPicImg.isHidden = true
        }
        // pmtwo
        if aqiDetail["PM2.5Status"]! == "良好"{
            pmTwoPicImg.image = UIImage(named: String("Green"))
            pmTwoPicImg.isHidden = false
        }else if aqiDetail["PM2.5Status"]! == "普通"{
            pmTwoPicImg.image = UIImage(named: String("Yellow"))
            pmTwoPicImg.isHidden = false
        }else{
            pmTwoPicImg.isHidden = true
        }
        
        pmTValueLbl.text? = aqiDetail["PM2.5"]!
        pmTwoSLbl.text? = aqiDetail["PM2.5Status"]!
        
        pmTenValLbl.text? = aqiDetail["PM10"]!
        coValueLbl.text? = aqiDetail["Co"]!
        soValueLbl.text? = aqiDetail["So2"]!
        othreValueLbl.text? = aqiDetail["O3"]!
        
        pmTenAvgLbl.text? = aqiDetail["PM10Avg"]!
        pmTwoAvgLbl.text? = aqiDetail["PM2.5Avg"]!
 
        countyLbl.text? = aqiDetail["County"]!
        siteLbl.text? = aqiDetail["SiteName"]!
    }
    @IBAction func toMainAction(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MainView") {
            present(controller, animated: true, completion: nil)
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
