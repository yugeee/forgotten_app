//
//  FareTableViewController.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2019/12/03.
//  Copyright © 2019 弓削直樹. All rights reserved.
//

import UIKit

class FareTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var yearsMonthsPicker: UIPickerView!
    
    var fares :Fares = Fares()
    
    var fare_masters :[FareMaster] = [FareMaster()]
    
    var fare_master_purposes :[String] = []
    
    var fareCell :FareTableViewCell = FareTableViewCell()
    
    let years:[String] = ["2019","2020"]
    let months:[String] = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    var saved = false
    
    // DatePickerに日付を入れるためDate型にする
    // フォーマッタの用意
    let f = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        f.timeStyle = .none
        f.dateStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "yyyy-MM-dd"
        
        // 1行目は空オブジェクトを入れる
        fare_masters.append(FareMaster())
        
        /* pickerにタグを設定して入れる値を制御
         * tag 0 : 年月
         * tag 1 : 運賃マスタ tableViewで代入する
         */
        yearsMonthsPicker.tag = 0
        
        getFareMaster()
        getFares(year: "2019",month: "5")
    }
    
    func getFares(year: String, month: String) {
        
        self.yearsMonthsPicker.selectRow(self.years.firstIndex(of: year) ?? 0, inComponent: 0, animated: false)
        self.yearsMonthsPicker.selectRow(self.months.firstIndex(of: month) ?? 0, inComponent: 1, animated: false)
        
        let url = URL(string: "http://127.0.0.1:5000/api/fares/\(year)/\(month)/")
        let request = URLRequest(url: url!)
            
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
              
            if error == nil, let data = data, let _ = response as? HTTPURLResponse {
                
                do {
                    let response = response as? HTTPURLResponse
                    if response?.statusCode == 200 {
                        self.fares = try JSONDecoder().decode(Fares.self, from: data)
                    } else {
                        self.fares.fares = [Fare()]
                        
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
                        
                        for master in self.fare_masters {
                            self.fare_master_purposes.append(master.purpose)
                        }
                    
                    } else {
                        //self.getNewAttendance(year: year, month: month)
                    }
                } catch let error {
                    print("## error: \(error)")
                }
            }
        }
        // 通信開始
        task.resume()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
           return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fares.fares?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 勤怠セル取得
        fareCell = (tableView.dequeueReusableCell(withIdentifier: "fare", for: indexPath) as? FareTableViewCell)!
            
        fareCell.fareMastersPicker.tag = 1
        
        let fareList = fares.fares
            
        // 日付取得　エラー時は創業日を入れてる
        var date = Date()
        if(fareList?[indexPath.row].date != ""){
            date = f.date(from: (fareList?[indexPath.row].date) ?? "2011-06-17")!
        }
            
        fareCell.fareMastersPicker.selectRow(fare_master_purposes.firstIndex(of: fareList?[indexPath.row].purpose ?? "") ?? 0 , inComponent: 0, animated: false)
            
        fareCell.datePicker.date = date
            
        fareCell.purposeText.text = fareList?[indexPath.row].purpose
            
        fareCell.transportationText.text = fareList?[indexPath.row].transportation
            
        fareCell.departureText.text = fareList?[indexPath.row].departure
            
        fareCell.arrivalText.text = fareList?[indexPath.row].arrival
            
        fareCell.roundTripSwitch.isOn = ((fareList?[indexPath.row].round_trip) == 1)
            
        fareCell.fareText.text = fareList?[indexPath.row].fare.description
            
        // 再読み込み用（追加されたセルの操作を無効にするため）
        fareCell.fareMastersPicker.isUserInteractionEnabled = false
        fareCell.datePicker.isUserInteractionEnabled = false
        fareCell.purposeText.isUserInteractionEnabled = false
        fareCell.transportationText.isUserInteractionEnabled = false
        fareCell.departureText.isUserInteractionEnabled = false
        fareCell.arrivalText.isUserInteractionEnabled = false
        fareCell.roundTripSwitch.isUserInteractionEnabled = false
        fareCell.fareText.isUserInteractionEnabled = false
        fareCell.deleteButton.isUserInteractionEnabled = false
            
        return fareCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択したセル取得
        fareCell = (tableView.cellForRow(at: indexPath) as? FareTableViewCell)!
        fareCell.fareMastersPicker.isUserInteractionEnabled = true
        fareCell.datePicker.isUserInteractionEnabled = true
        fareCell.purposeText.isUserInteractionEnabled = true
        fareCell.transportationText.isUserInteractionEnabled = true
        fareCell.departureText.isUserInteractionEnabled = true
        fareCell.arrivalText.isUserInteractionEnabled = true
        fareCell.roundTripSwitch.isUserInteractionEnabled = true
        fareCell.fareText.isUserInteractionEnabled = true
        fareCell.deleteButton.isUserInteractionEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 選択したセル取得
        fareCell = (tableView.cellForRow(at: indexPath) as? FareTableViewCell)!
        
        fareCell.fareMastersPicker.isUserInteractionEnabled = false
        fareCell.datePicker.isUserInteractionEnabled = false
        fareCell.purposeText.isUserInteractionEnabled = false
        fareCell.transportationText.isUserInteractionEnabled = false
        fareCell.departureText.isUserInteractionEnabled = false
        fareCell.arrivalText.isUserInteractionEnabled = false
        fareCell.roundTripSwitch.isUserInteractionEnabled = false
        fareCell.fareText.isUserInteractionEnabled = false
        fareCell.deleteButton.isUserInteractionEnabled = false
    }
    
    
    // yearsMonthsPickerの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if pickerView.tag == 0 {
            return 2
        }
        
        if pickerView.tag == 1 {
            return 1
        }
        return 0
    }
    
    // Pickerに表示する値の数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
            switch component {
            case 0:
                return years.count
            case 1:
                return months.count
            default:
                return 0
            }
        }
        
        if pickerView.tag == 1 {
            return fare_master_purposes.count
        }
        
        return 0
    }
    
     // Pickerに表示する値を返すデリゲートメソッド.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            switch component {
                case 0:
                    return years[row]
                case 1:
                    return months[row]
                default:
                    return "error"
            }
        }
        
        if pickerView.tag == 1 {
            switch component {
                case 0:
                    return fare_master_purposes[row]
                default:
                    return "error"
            }
        }
        return "error"
    }
    
    // pickerが選択された際に呼ばれるデリゲートメソッド
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
            let year  = years[yearsMonthsPicker.selectedRow(inComponent: 0)]
            let month = months[yearsMonthsPicker.selectedRow(inComponent: 1)]
            getFares(year: year,month: month)
            
        }
        
        if pickerView.tag == 1 {
            
            var fareList = fares.fares
            
            let indexPath = tableView!.indexPathForSelectedRow!
            
            let fare = (fareList?[indexPath.row])!
            
            fareCell = tableView.cellForRow(at: indexPath) as! FareTableViewCell
            
            let purpose  = fare_master_purposes[fareCell.fareMastersPicker.selectedRow(inComponent: 0)]
            
            var idx = 0
            if(purpose != "") {
                idx = fare_master_purposes.firstIndex(of: purpose) ?? 0
            }
            
            let fare_master = fare_masters[idx]
            
            let fixed_fare = changeFare(fare: fare, fareCell: fareCell, fare_master: fare_master)
            
            fareList?[indexPath.row] = fixed_fare
        }
    }
    
    /* 勤怠マスタが変更された時に動く
     * 表示しているセルとオブジェクトのメンバを使用するマスタの値に変更
     */
    func changeFare (fare: Fare, fareCell: FareTableViewCell, fare_master: FareMaster) -> Fare {
        
        fareCell.fareMastersPicker.selectRow(fare_master_purposes.firstIndex(of: fare_master.purpose ) ?? 0 , inComponent: 0, animated: false)
        
        fareCell.purposeText.text = fare_master.purpose
        
        fareCell.transportationText.text = fare_master.transportation
        
        fareCell.departureText.text = fare_master.departure
        
        fareCell.arrivalText.text = fare_master.arrival
        
        fareCell.roundTripSwitch.isOn = ((fare_master.round_trip) == 1)
        
        fareCell.fareText.text = fare_master.fare.description
        
        fare.purpose = fare_master.purpose
        
        fare.transportation = fare_master.transportation
        
        fare.round_trip = fare_master.round_trip
        
        fare.fare = fare_master.fare
        
        return fare
    }
    
    /*
     * セル追加・削除時にテーブル更新を行う
     * 追加時は子クラスから呼ばれるので本当はやりたくない
     */
    func updateTable(fareList: [Fare], saved: Bool) {
        fares.fares = fareList
        tableView.reloadData()
    }
    
    /*
     * セル削除
     */
    @IBAction func pushedDeleteButton(_ sender: Any) {
        var fareList = fares.fares
        
        let indexPath = tableView!.indexPathForSelectedRow!
        
        fareList?.remove(at: indexPath.row)
        
        updateTable(fareList: fareList!, saved: false)
    }
    
    
    @IBAction func changedDatePicker(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        let fare = (fares.fares?[indexPath.row])!
        
        fareCell = tableView.cellForRow(at: indexPath) as! FareTableViewCell
        
        fare.date =  f.string(from: fareCell.datePicker.date)
    }
    
    @IBAction func changedPurposeText(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        let fare = (fares.fares?[indexPath.row])!
        
        fareCell = tableView.cellForRow(at: indexPath) as! FareTableViewCell
        
        fare.purpose =  fareCell.purposeText.text!
    }
    
    
    @IBAction func changedTransportationText(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        let fare = (fares.fares?[indexPath.row])!
        
        fareCell = tableView.cellForRow(at: indexPath) as! FareTableViewCell
        
        fare.transportation =  fareCell.transportationText.text!
    }
    
    
    @IBAction func changedDepartureText(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        let fare = (fares.fares?[indexPath.row])!
        
        fareCell = tableView.cellForRow(at: indexPath) as! FareTableViewCell
        
        fare.departure =  fareCell.departureText.text!
    }
    
    
    @IBAction func changedArrivalText(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        let fare = (fares.fares?[indexPath.row])!
        
        fareCell = tableView.cellForRow(at: indexPath) as! FareTableViewCell
        
        fare.arrival =  fareCell.arrivalText.text!
    }
    
    @IBAction func changedRoundtripSwitch(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        let fare = (fares.fares?[indexPath.row])!
        
        fareCell = tableView.cellForRow(at: indexPath) as! FareTableViewCell
        
        fare.round_trip =  fareCell.roundTripSwitch.isOn ? 1 : 0
    }
    
    @IBAction func changedFareText(_ sender: Any) {
        let indexPath = tableView!.indexPathForSelectedRow!
        
        let fare = (fares.fares?[indexPath.row])!
        
        fareCell = tableView.cellForRow(at: indexPath) as! FareTableViewCell
        
        fare.fare = Int(fareCell.fareText.text ?? "0") ?? 0
        
        // 0になるかも知れないので再表示させる
        fareCell.fareText.text = fare.fare.description
    }
    
}
