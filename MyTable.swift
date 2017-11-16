//
//  MyTable.swift
//  MedicalCenter
//
//  Created by D7703_22 on 2017. 11. 9..
//  Copyright © 2017년 D7703_22. All rights reserved.
//

import UIKit

class MyTable: UITableViewController, XMLParserDelegate {
    
    let apiKey = "JJQju7Am3tWbaQaoltATRnZnYWcSOsLhLxaGRdFXwCunSJOyoaq6Chl31Rpu2UZ6956S0jmu%2B8ElwfpoMFjIIQ%3D%3D"
    
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var currentElement:String = ""
    var currentPage = 1
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str = "http://opendata.busan.go.kr/openapi/service/RentBike/getRentBikeInfoDetail?serviceKey=\(apiKey)&pageNo=\(currentPage)&startPage=1&numOfRows=10&pageSize=10&language=kor"
        
        
        if let url = URL(string: str), let parser = XMLParser(contentsOf: url) {
            parser.delegate = self
            
            let success = parser.parse()
            if success {
                print("parse success!1")
                print(items.count)
                tableView.reloadData()
            } else {
                print("parse failure!1")
            }
        }
        
        self.title = "부산 자전거 대여소"
        
    }
    
    
    @IBAction func actPrev(_ sender: UIBarButtonItem) {

        
        if currentPage != 1{
            currentPage -= 1
            items.removeAll()
            
            success()
        }
    }
    
    @IBAction func actNext(_ sender: UIBarButtonItem) {
        
        currentPage += 1
        count += 1
        
        items.removeAll()
        
        if count == 3 {
            count = 0
            currentPage = 1
            success()
        }else {
            success()
        }
        
        
        
        
        
    }
    
    func success() {
        
        var str = ""
        if currentPage == 1 {
             str = "http://opendata.busan.go.kr/openapi/service/RentBike/getRentBikeInfoDetail?serviceKey=\(apiKey)&pageNo=\(currentPage)&startPage=\(currentPage - 1)&numOfRows=10&pageSize=10&language=kor"
        } else {
             str = "http://opendata.busan.go.kr/openapi/service/RentBike/getRentBikeInfoDetail?serviceKey=\(apiKey)&pageNo=\(currentPage)&startPage=\(currentPage + 1)&numOfRows=10&pageSize=10&language=kor"
        }
        
        
        if let url = URL(string:str),
            let parser = XMLParser(contentsOf: url){
            parser.delegate = self
            
            let success = parser.parse()
            if success {
                print("parse success!")
                print(items.count)
                tableView.reloadData()
            } else {
                print("parse failure!")
            }
        }
    }
    
    // MARK: - XMLParser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName.trimmingCharacters(in: .whitespacesAndNewlines)
        if elementName == "item"{
            item = [:]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if item[currentElement] == nil {
            item[currentElement] = string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "item") {
            items.append(item)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("items.count = \(items.count)")
        print(items)
        
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let book = items[indexPath.row]
        
        let lblTitle = cell.viewWithTag(1) as? UILabel
        lblTitle?.text = book["office"]
        
        let lblAuthor = cell.viewWithTag(2) as? UILabel
        lblAuthor?.text = book["openTime"]
        
        let lblPub = cell.viewWithTag(3) as? UILabel
        lblPub?.text = book["rentAddr"]
        
        let lblPrice = cell.viewWithTag(4) as? UILabel
        lblPrice?.text = book["rentTel"]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //del이라는 식별자를 찾아서 알맞게 보낸다
        if segue.identifier == "map"{
            let detailVC = segue.destination as! Maps
            let selectedPath = tableView.indexPathForSelectedRow
            
            let itme = items[(selectedPath?.row)!]
            
            //테이블에서 선택된 데이터를 찾아 del에 넣어 보낸다
            let title = itme["office"]! as String
            let lat = itme["rentAddr"]! as String
            let tol = itme["rentTel"]! as String
           
            detailVC.tits = title
            detailVC.geos = lat
            detailVC.tell = tol
            
        }
        
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //    if let detailViewController = segue.destination as? DetailViewController
    //    ,let indexPath = tableView.indexPathForSelectedRow {
    //    let book = items[indexPath.row]
    //    detailViewController.linkURL = book["link"]
    //    }
    //    }
    
    
}
