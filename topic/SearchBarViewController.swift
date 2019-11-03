//
//  SearchBarViewController.swift
//  topic
//
//  Created by 許維倫 on 2019/11/2.
//  Copyright © 2019 許維倫. All rights reserved.
//

import UIKit
import CoreLocation

class SearchBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableVIew: UITableView!
    let userdefault = UserDefaults.standard
    let cityArray = ["台北市中正區", "台北市信義區", "台北市大安區", "基隆市中正區", "台北市文山區"]
    var searchArray = [String]()
    var searching = false
    var chooseCities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableVIew.delegate = self
        searchTableVIew.dataSource = self
        searchBar.delegate = self
       
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchArray.count
        }else{
            return cityArray.count
        }
      
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if searching{
            cell.textLabel!.text = searchArray[indexPath.row]

        }else{
            cell.textLabel!.text = cityArray[indexPath.row]
            cell.isHidden = true
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curCell = tableView.cellForRow(at: indexPath)
        let chooseCity = curCell?.textLabel?.text as! String
        chooseCities.append(chooseCity)
        userdefault.set(chooseCities, forKey: "Cities")
       
        self.performSegue(withIdentifier: "toSearchTable", sender: self)
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchArray = cityArray.filter({$0.prefix(searchText.count) == searchText})
        searching = true
        searchTableVIew.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = " "
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchTable"{
            let destViewController: SearchTableViewController = segue.destination as! SearchTableViewController
            destViewController.city = chooseCities
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
