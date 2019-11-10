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
    let cityArray = ["臺北市中正區", "臺北市大同區", "臺北市中山區", "臺北市萬華區", "臺北市信義區", "臺北市松山區", "臺北市大安區", "臺北市南港區", "臺北市北投區", "臺北市內湖區", "臺北市士林區", "臺北市文山區","新北市板橋區", "新北市新莊區", "新北市泰山區", "新北市林口區", "新北市淡水區", "新北市金山區", "新北市八里區", "新北市萬里區", "新北市石門區", "新北市三芝區", "新北市瑞芳區", "新北市汐止區", "新北市平溪區", "新北市貢寮區", "新北市雙溪區", "新北市深坑區", "新北市石碇區", "新北市新店區", "新北市坪林區", "新北市烏來區", "新北市中和區", "新北市永和區", "新北市土城區", "新北市三峽區", "新北市樹林區", "新北市鶯歌區", "新北市三重區", "新北市蘆洲區", "新北市五股區", "基隆市仁愛區", "基隆市中正區", "基隆市信義區", "基隆市中山區", "基隆市安樂區", "基隆市暖暖區", "基隆市七堵區", "桃園市桃園區", "桃園市中壢區", "桃園市平鎮區", "桃園市八德區", "桃園市楊梅區", "桃園市蘆竹區", "桃園市龜山區", "桃園市龍潭區", "桃園市大溪區", "桃園市大園區", "桃園市觀音區", "桃園市新屋區", "桃園市復興區", "新竹縣竹北市", "新竹縣竹東鎮", "新竹縣新埔鎮", "新竹縣關西鎮", "新竹縣峨眉鄉", "新竹縣寶山鄉", "新竹縣北埔鄉", "新竹縣橫山鄉", "新竹縣芎林鄉", "新竹縣湖口鄉", "新竹縣新豐鄉", "新竹縣尖石鄉", "新竹縣五峰鄉", "新竹市東區", "新竹市北區", "新竹市香山區", "臺中市中區", "臺中市東區", "臺中市南區", "臺中市西區", "臺中市北區", "臺中市北屯區", "臺中市西屯區", "臺中市南屯區", "臺中市太平區", "臺中市大里區", "臺中市霧峰區", "臺中市烏日區", "臺中市豐原區", "臺中市后里區", "臺中市東勢區", "臺中市石岡區", "臺中市新社區", "臺中市和平區", "臺中市神岡區", "臺中市潭子區", "臺中市大雅區", "臺中市大肚區", "臺中市龍井區", "臺中市沙鹿區", "臺中市梧棲區", "臺中市清水區", "臺中市大甲區", "臺中市外埔區", "臺中市大安區",  "南投縣南投市", "南投縣埔里鎮", "南投縣草屯鎮", "南投縣竹山鎮", "南投縣集集鎮", "南投縣名間鄉", "南投縣鹿谷鄉", "南投縣中寮鄉", "南投縣魚池鄉", "南投縣國姓鄉", "南投縣水里鄉", "南投縣信義鄉", "南投縣仁愛鄉",  "彰化縣彰化市", "彰化縣員林鎮", "彰化縣和美鎮", "彰化縣鹿港鎮", "彰化縣溪湖鎮", "彰化縣二林鎮", "彰化縣田中鎮", "彰化縣北斗鎮", "彰化縣花壇鄉", "彰化縣芬園鄉", "彰化縣大村鄉", "彰化縣永靖鄉", "彰化縣伸港鄉", "彰化縣線西鄉", "彰化縣福興鄉", "彰化縣秀水鄉", "彰化縣埔心鄉", "彰化縣埔鹽鄉", "彰化縣大城鄉", "彰化縣芳苑鄉", "彰化縣竹塘鄉", "彰化縣社頭鄉", "彰化縣二水鄉", "彰化縣田尾鄉", "彰化縣埤頭鄉", "彰化縣溪州鄉", "雲林縣斗六市", "雲林縣斗南鎮", "雲林縣虎尾鎮", "雲林縣西螺鎮", "雲林縣土庫鎮", "雲林縣北港鎮", "雲林縣莿桐鄉", "雲林縣林內鄉", "雲林縣古坑鄉", "雲林縣大埤鄉", "雲林縣崙背鄉", "雲林縣二崙鄉", "雲林縣麥寮鄉", "雲林縣臺西鄉", "雲林縣東勢鄉", "雲林縣褒忠鄉", "雲林縣四湖鄉", "雲林縣口湖鄉", "雲林縣水林鄉", "雲林縣元長鄉",  "嘉義縣太保市", "嘉義縣朴子市", "嘉義縣布袋鎮", "嘉義縣大林鎮", "嘉義縣民雄鄉", "嘉義縣溪口鄉", "嘉義縣新港鄉", "嘉義縣六腳鄉", "嘉義縣東石鄉", "嘉義縣義竹鄉", "嘉義縣鹿草鄉", "嘉義縣水上鄉", "嘉義縣中埔鄉", "嘉義縣竹崎鄉", "嘉義縣梅山鄉", "嘉義縣番路鄉", "嘉義縣大埔鄉", "嘉義縣阿里山鄉", "臺南市中西區", "臺南市東區", "臺南市南區", "臺南市北區", "臺南市安平區", "臺南市安南區", "臺南市永康區", "臺南市歸仁區", "臺南市新化區", "臺南市左鎮區", "臺南市玉井區", "臺南市楠西區", "臺南市南化區", "臺南市仁德區", "臺南市關廟區", "臺南市龍崎區", "臺南市官田區", "臺南市麻豆區", "臺南市佳里區", "臺南市西港區", "臺南市七股區", "臺南市將軍區", "臺南市學甲區", "臺南市北門區", "臺南市新營區", "臺南市後壁區", "臺南市白河區", "臺南市東山區", "臺南市六甲區", "臺南市下營區", "臺南市柳營區", "臺南市鹽水區", "臺南市善化區", "臺南市大內區", "臺南市山上區", "臺南市新市區", "臺南市安定區", "高雄市楠梓區", "高雄市左營區", "高雄市鼓山區", "高雄市三民區", "高雄市鹽埕區", "高雄市前金區", "高雄市新興區", "高雄市苓雅區", "高雄市前鎮區", "高雄市小港區", "高雄市旗津區", "高雄市鳳山區", "高雄市大寮區", "高雄市鳥松區", "高雄市林園區", "高雄市仁武區", "高雄市大樹區", "高雄市大社區", "高雄市岡山區", "高雄市路竹區", "高雄市橋頭區", "高雄市梓官區", "高雄市彌陀區", "高雄市永安區", "高雄市燕巢區", "高雄市田寮區", "高雄市阿蓮區", "高雄市茄萣區", "高雄市湖內區", "高雄市旗山區", "高雄市美濃區", "高雄市內門區", "高雄市杉林區", "高雄市甲仙區", "高雄市六龜區", "高雄市茂林區", "高雄市桃源區", "高雄市那瑪夏區", "嘉義市東區", "嘉義市西區", "屏東縣屏東市", "屏東縣潮州鎮", "屏東縣東港鎮", "屏東縣恆春鎮", "屏東縣萬丹鄉", "屏東縣長治鄉", "屏東縣麟洛鄉", "屏東縣九如鄉", "屏東縣里港鄉", "屏東縣鹽埔鄉", "屏東縣高樹鄉", "屏東縣萬巒鄉", "屏東縣內埔鄉", "屏東縣竹田鄉", "屏東縣新埤鄉", "屏東縣枋寮鄉", "屏東縣新園鄉", "屏東縣崁頂鄉", "屏東縣林邊鄉", "屏東縣南州鄉", "屏東縣佳冬鄉", "屏東縣琉球鄉", "屏東縣車城鄉", "屏東縣滿州鄉", "屏東縣枋山鄉", "屏東縣霧台鄉", "屏東縣瑪家鄉", "屏東縣泰武鄉", "屏東縣來義鄉", "屏東縣春日鄉", "屏東縣獅子鄉", "屏東縣牡丹鄉", "屏東縣三地門鄉",  "宜蘭縣宜蘭市", "宜蘭縣羅東鎮", "宜蘭縣蘇澳鎮", "宜蘭縣頭城鎮", "宜蘭縣礁溪鄉", "宜蘭縣壯圍鄉", "宜蘭縣員山鄉", "宜蘭縣冬山鄉", "宜蘭縣五結鄉", "宜蘭縣三星鄉", "宜蘭縣大同鄉", "宜蘭縣南澳鄉",  "花蓮縣花蓮市", "花蓮縣鳳林鎮", "花蓮縣玉里鎮", "花蓮縣新城鄉", "花蓮縣吉安鄉", "花蓮縣壽豐鄉", "花蓮縣秀林鄉", "花蓮縣光復鄉", "花蓮縣豐濱鄉", "花蓮縣瑞穗鄉", "花蓮縣萬榮鄉", "花蓮縣富里鄉", "花蓮縣卓溪鄉", "臺東縣臺東市", "臺東縣成功鎮", "臺東縣關山鎮", "臺東縣長濱鄉", "臺東縣海端鄉", "臺東縣池上鄉", "臺東縣東河鄉", "臺東縣鹿野鄉", "臺東縣延平鄉", "臺東縣卑南鄉", "臺東縣金峰鄉", "臺東縣大武鄉", "臺東縣達仁鄉", "臺東縣綠島鄉", "臺東縣蘭嶼鄉", "臺東縣太麻里鄉",  "澎湖縣馬公市", "澎湖縣湖西鄉", "澎湖縣白沙鄉", "澎湖縣西嶼鄉", "澎湖縣望安鄉", "澎湖縣七美鄉",  "金門縣金城鎮", "金門縣金湖鎮", "金門縣金沙鎮", "金門縣金寧鄉", "金門縣烈嶼鄉", "金門縣烏坵鄉",  "連江縣南竿鄉", "連江縣北竿鄉", "連江縣莒光鄉", "連江縣東引鄉"]
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
       
        // self.performSegue(withIdentifier: "toSearchTable", sender: self)
        
        if #available(iOS 13.0, *) {
            if let controller = storyboard?.instantiateViewController(identifier: "SearchTableNav") {
                controller.isModalInPresentation = true
                present(controller, animated: true, completion: nil)
            }
        } else {
            // Fallback on earlier versions
            self.performSegue(withIdentifier: "SearchTableNav", sender: self)
        }

        
        
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




