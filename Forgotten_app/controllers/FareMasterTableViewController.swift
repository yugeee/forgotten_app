//
//  FareMasterTableViewController.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2020/01/11.
//  Copyright © 2020 弓削直樹. All rights reserved.
//

import UIKit

class FareMasterTableViewController: UITableViewController {
    
    var fare_masters :[FareMaster] = []
    
    var fareMasterCell :FareMasterTableViewCell = FareMasterTableViewCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFareMaster()
    }
    
    func getFareMaster() {
        
        let url = URL(string: "http://127.0.0.1:5000/api/fare_masters/")
        let request = URLRequest(url: url!)
            
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
              
            if error == nil, let data = data, let _ = response as? HTTPURLResponse {
                
                do {
                    let response = response as? HTTPURLResponse
                    if response?.statusCode == 200 {
                        let masters = try JSONDecoder().decode([FareMaster].self, from: data)
                        
                        for master in masters{
                            self.fare_masters.append(master)
                        }
                    
                    } else {
                        //self.getNewAttendance(year: year, month: month)
                    }
                } catch let error {
                    print("## error: \(error)")
                }
                
            
                // データ取得後にテーブル再描画
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        // 通信開始
        task.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fare_masters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 勤怠セル取得
        fareMasterCell = (tableView.dequeueReusableCell(withIdentifier: "fare_master", for: indexPath) as? FareMasterTableViewCell)!
            
        fareMasterCell.purposeText.text = fare_masters[indexPath.row].purpose
            
        fareMasterCell.transportationText.text = fare_masters[indexPath.row].transportation
            
        fareMasterCell.departureText.text = fare_masters[indexPath.row].departure
            
        fareMasterCell.arrivalText.text = fare_masters[indexPath.row].arrival
            
        fareMasterCell.roundTripSwitch.isOn = ((fare_masters[indexPath.row].round_trip) == 1)
            
        fareMasterCell.fareText.text = fare_masters[indexPath.row].fare.description
            
        // 再読み込み用（追加されたセルの操作を無効にするため）
        fareMasterCell.purposeText.isUserInteractionEnabled = false
        fareMasterCell.transportationText.isUserInteractionEnabled = false
        fareMasterCell.departureText.isUserInteractionEnabled = false
        fareMasterCell.arrivalText.isUserInteractionEnabled = false
        fareMasterCell.roundTripSwitch.isUserInteractionEnabled = false
        fareMasterCell.fareText.isUserInteractionEnabled = false
        fareMasterCell.deleteButton.isUserInteractionEnabled = false
            
        return fareMasterCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        fareMasterCell = (tableView.cellForRow(at: indexPath) as? FareMasterTableViewCell)!
        
        fareMasterCell.purposeText.isUserInteractionEnabled = true
        
        fareMasterCell.transportationText.isUserInteractionEnabled = true
        fareMasterCell.departureText.isUserInteractionEnabled = true
        fareMasterCell.arrivalText.isUserInteractionEnabled = true
        fareMasterCell.roundTripSwitch.isUserInteractionEnabled = true
        fareMasterCell.fareText.isUserInteractionEnabled = true
        fareMasterCell.deleteButton.isUserInteractionEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        fareMasterCell = (tableView.cellForRow(at: indexPath) as? FareMasterTableViewCell)!
        
        fareMasterCell.purposeText.isUserInteractionEnabled = false
        fareMasterCell.transportationText.isUserInteractionEnabled = false
        fareMasterCell.departureText.isUserInteractionEnabled = false
        fareMasterCell.arrivalText.isUserInteractionEnabled = false
        fareMasterCell.roundTripSwitch.isUserInteractionEnabled = false
        fareMasterCell.fareText.isUserInteractionEnabled = false
        fareMasterCell.deleteButton.isUserInteractionEnabled = false
        
    }
    
    /*
     * セル追加・削除時にテーブル更新を行う
     * 追加時は子クラスから呼ばれるので本当はやりたくない
     */
    func updateTable(fare_masters: [FareMaster]) {
        self.fare_masters = fare_masters
        tableView.reloadData()
    }
    
    /*
    * セル削除
    */
    @IBAction func pushedDeleteButton(_ sender: Any) {
        
        let indexPath = tableView!.indexPathForSelectedRow!
        
        fare_masters.remove(at: indexPath.row)
        
        updateTable(fare_masters: fare_masters)
    }
    
    
    @IBAction func changedPurposeText(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        fareMasterCell = (tableView.cellForRow(at: indexPath) as? FareMasterTableViewCell)!
        
        let fare_master = fare_masters[indexPath.row]
        
        fare_master.purpose = fareMasterCell.purposeText.text!
    }
    
    
    @IBAction func changedTransportationText(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        fareMasterCell = (tableView.cellForRow(at: indexPath) as? FareMasterTableViewCell)!
        
        let fare_master = fare_masters[indexPath.row]
        
        fare_master.transportation = fareMasterCell.transportationText.text!
    }
    
    
    @IBAction func changedDepartureText(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        fareMasterCell = (tableView.cellForRow(at: indexPath) as? FareMasterTableViewCell)!
        
        let fare_master = fare_masters[indexPath.row]
        
        fare_master.departure = fareMasterCell.departureText.text!
    }
    
    
    @IBAction func changedArrivalText(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        fareMasterCell = (tableView.cellForRow(at: indexPath) as? FareMasterTableViewCell)!
        
        let fare_master = fare_masters[indexPath.row]
        
        fare_master.arrival = fareMasterCell.arrivalText.text!
    }
    
    
    @IBAction func changedRoundtripSwitch(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        fareMasterCell = (tableView.cellForRow(at: indexPath) as? FareMasterTableViewCell)!
        
        let fare_master = fare_masters[indexPath.row]
        
        fare_master.round_trip = fareMasterCell.roundTripSwitch.isOn ? 1 : 0
    }
    
    
    @IBAction func changedFareText(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        fareMasterCell = (tableView.cellForRow(at: indexPath) as? FareMasterTableViewCell)!
        
        let fare_master = fare_masters[indexPath.row]
        
        fare_master.fare = Int(fareMasterCell.fareText.text ?? "0") ?? 0
        
        // 0になるかも知れないので再表示させる
        fareMasterCell.fareText.text = fare_master.fare.description
    }
}
