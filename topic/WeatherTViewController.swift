//
//  WeatherTViewController.swift
//  topic
//
//  Created by 許維倫 on 2019/8/6.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit

class WeatherDetailCell: UITableViewCell {
    
    @IBOutlet weak var temValueLabel: UILabel!
    @IBOutlet weak var uviValueLabel: UILabel!
    @IBOutlet weak var windirLabel: UILabel!
    @IBOutlet weak var windspeLabel: UILabel!
    @IBOutlet weak var humdLabel: UILabel!
    @IBOutlet weak var rainfallLabel: UILabel!
    @IBOutlet weak var maxTemLabel: UILabel!
    @IBOutlet weak var minTemLabel: UILabel!
    @IBOutlet weak var uviStatusLabel: UILabel!
    @IBOutlet weak var temImage: UIImageView!
    @IBOutlet weak var uviImage: UIImageView!
    
}

class WeatherTViewController: UITableViewController {
    var weatherArray: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print(weatherArray)
        

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherDetailCell", for: indexPath) as! WeatherDetailCell

        // Configure the cell...
        cell.temValueLabel.text? = weatherArray[0]
        cell.uviValueLabel.text? = weatherArray[1]
        cell.uviStatusLabel.text? = weatherArray[2]
        cell.windirLabel.text? = weatherArray[3]
        cell.windspeLabel.text? = weatherArray[4]
        cell.humdLabel.text? = weatherArray[5]
        cell.rainfallLabel.text? = weatherArray[6]
        cell.maxTemLabel.text? = weatherArray[7]
        cell.minTemLabel.text? = weatherArray[8]
        
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
