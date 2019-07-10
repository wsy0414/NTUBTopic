//
//  TableViewSectionset.swift
//  topic
//
//  Created by 許維倫 on 2019/5/15.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit

// 設定畫面
class TableViewSectionset: UITableViewController {
    
    var sectionTitle = ["加入小工具", "更多小工具"]
    var sectionRow = [] as[String] // 加入小工具
    var sectionInsertRow = [] as [String] // 更多小工具
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true // 調成可編輯狀態
    }

    // MARK: - Table view data source
    // 2個Section
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    // row的行數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return sectionRow.count
        }else{
            return sectionInsertRow.count
        }
    }
    // cell 設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.section == 0{
            cell.textLabel?.text = sectionRow[indexPath.row]
            return cell
        }else{
            cell.textLabel?.text = sectionInsertRow[indexPath.row]
            return cell
        }
    }
    // 編輯 = true
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    // 調換順序 = true
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
       
        return true
    }
    // 調換順序 setting
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let number = sectionRow[fromIndexPath.row]
        sectionRow.remove(at: fromIndexPath.row)
        sectionRow.insert(number, at: to.row)
    }
    // Delete and insert
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if sectionTitle[indexPath.section] == "加入小工具"{
            return UITableViewCell.EditingStyle.delete
        }else{
            return UITableViewCell.EditingStyle.insert
        }
        
    }
    // 編輯 EditingStyle
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let number = sectionRow[indexPath.row]
            sectionRow.remove(at: indexPath.row)
            sectionInsertRow.append(number)
            tableView.reloadData()
        }else if editingStyle == .insert{
            let number = sectionInsertRow[indexPath.row]
            sectionRow.append(number)
            sectionInsertRow.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
   
    
    // sectionHeader
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    // headerHeigh
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    // 切換畫面傳值 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController: ViewController = segue.destination as! ViewController
        destViewController.tableViewSection = sectionRow
        destViewController.tableViewSection_under = sectionInsertRow
    }
   
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
