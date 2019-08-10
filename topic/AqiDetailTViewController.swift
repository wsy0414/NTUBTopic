//
//  AqiDetailTViewController.swift
//  topic
//
//  Created by 許維倫 on 2019/7/28.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit

class AqiDetailCell: UITableViewCell{
    
    @IBOutlet weak var aqiValueLabel: UILabel!
    @IBOutlet weak var aqiStatusLabel: UILabel!
    @IBOutlet weak var aqiImage: UIImageView!
    @IBOutlet weak var pmtwoValueLabel: UILabel!
    @IBOutlet weak var pmtwoStatusLabel: UILabel!
    @IBOutlet weak var pmtwoImage: UIImageView!
    @IBOutlet weak var siteValueLabel: UILabel!
    @IBOutlet weak var pmtenValueLabel: UILabel!
    @IBOutlet weak var coValueLabel: UILabel!
    @IBOutlet weak var soValueLabel: UILabel!
    @IBOutlet weak var othrValueLabel: UILabel!
    @IBOutlet weak var pmtwoAValueLabel: UILabel!
    @IBOutlet weak var pmtenAValue: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    
}

class AqiDetailTViewController: UITableViewController {
    var qualityArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(qualityArray)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
       
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aqiDetailCell", for: indexPath) as! AqiDetailCell
        // Configure the cell...
        cell.aqiValueLabel.text? = qualityArray[0]
        cell.pmtwoValueLabel.text? = qualityArray[1]
        cell.aqiStatusLabel.text? = qualityArray[2]
        cell.pmtwoStatusLabel.text? = qualityArray[3]
        cell.pmtenValueLabel.text? = qualityArray[4]
        cell.coValueLabel.text? = qualityArray[5]
        cell.soValueLabel.text? = qualityArray[6]
        cell.othrValueLabel.text? = qualityArray[7]
        cell.pmtwoAValueLabel.text? = qualityArray[8]
        cell.pmtenAValue.text? = qualityArray[9]
        cell.countyLabel.text? = qualityArray[10]
        cell.siteValueLabel.text? = qualityArray[11]
        cell.datetimeLabel.text? = qualityArray[12]
        // aqi
        if qualityArray[2] == "良好"{
            cell.aqiImage.image = UIImage(named: String("Green"))
            cell.aqiImage.isHidden = false
        }else if qualityArray[2] == "普通"{
            cell.aqiImage.image = UIImage(named: String("Yellow"))
            cell.aqiImage.isHidden = false
        }else{
            cell.aqiImage.isHidden = true
        }
        // pmtwo
        if qualityArray[3] == "良好"{
            cell.pmtwoImage.image = UIImage(named: String("Green"))
            cell.pmtwoImage.isHidden = false
        }else if qualityArray[3] == "普通"{
            cell.pmtwoImage.image = UIImage(named: String("Yellow"))
            cell.pmtwoImage.isHidden = false
        }else{
            cell.pmtwoImage.isHidden = true
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
