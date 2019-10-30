//
//  WeatherDetailViewController.swift
//  topic
//
//  Created by 許維倫 on 2019/10/20.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    @IBOutlet weak var weatherViewA: UIView!
    @IBOutlet weak var weatherViewB: UIView!
    
    @IBOutlet weak var temValueLbl: UILabel!
    @IBOutlet weak var uviValLbl: UILabel!
    @IBOutlet weak var windDirValLbl: UILabel!
    @IBOutlet weak var windSpdValLbl: UILabel!
    @IBOutlet weak var humValLbl: UILabel!
    @IBOutlet weak var rainfallValLbl: UILabel!
    
    @IBOutlet weak var uviSLbl: UILabel!
    @IBOutlet weak var maxTLbl: UILabel!
    @IBOutlet weak var minTLbl: UILabel!
    
    @IBOutlet weak var uviPicImg: UIImageView!
    
    @IBAction func toMainBtn(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MainView") {
            present(controller, animated: true, completion: nil)
        }
    }
    
    let userdefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setView()

        // Do any additional setup after loading the view.
    }
    
    
    func setData(){
        var weatherDetail = userdefaults.dictionary(forKey: "Weather") as! [String: String]
        temValueLbl.text? = weatherDetail["tempNow"]!
        uviValLbl.text? = weatherDetail["uviH"]!
        windDirValLbl.text? = weatherDetail["windDir"]!
        windSpdValLbl.text? = weatherDetail["windSpeed"]!
        humValLbl.text? = weatherDetail["humidity"]!
        rainfallValLbl.text? = weatherDetail["rainFall"]!
        maxTLbl.text? = weatherDetail["tempMax"]!
        minTLbl.text? = weatherDetail["tempMin"]!
        uviSLbl.text? = weatherDetail["uviStatus"]!
        
        switch weatherDetail["uviStatus"]{
        case "低量級":
            uviPicImg.image = UIImage(named: String("Green"))
        case "中量級":
            uviPicImg.image = UIImage(named: String("Yellow"))
        case "高量級":
            uviPicImg.image = UIImage(named: String("Red"))
        case "過量級":
            uviPicImg.image = UIImage(named: String("Purple"))
        case "危險級":
            uviPicImg.image = UIImage(named: String("Brown"))
        default:
            uviPicImg.image = UIImage(named: String("Gray"))
        }
       
    }
    
    func setView(){
        weatherViewA.layer.cornerRadius = 10
        weatherViewB.layer.cornerRadius = 10
        
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
