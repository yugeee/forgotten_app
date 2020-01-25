//
//  AttendancesList.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2019/09/25.
//  Copyright © 2019 弓削直樹. All rights reserved.
//

import UIKit

class AttendanceListController: UITableViewController , UIPickerViewDelegate, UIPickerViewDataSource
{

    
    @IBOutlet weak var yearsMonthsPicker: UIPickerView!
    let years:[String] = ["2019","2020"]
    let months:[String] = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    var attendances :Attendances = Attendances()
    
    var attendanceCell :AttendanceTableViewCell = AttendanceTableViewCell()
    
    var saved = false
    
    // DatePickerに時間を入れるためDate型にする
    // フォーマッタの用意
    let f = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        f.timeStyle = .short
        f.dateStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        
        getAttendances(year: "2019",month: "6")
    }
    
    func getAttendances(year: String, month: String) {
        self.yearsMonthsPicker.selectRow(self.years.firstIndex(of: year) ?? 0, inComponent: 0, animated: false)
        self.yearsMonthsPicker.selectRow(self.months.firstIndex(of: month) ?? 0, inComponent: 1, animated: false)
        
        let url = URL(string: "http://127.0.0.1:5000/api/attendances/\(year)/\(month)/")
        let request = URLRequest(url: url!)
            
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
              
            if error == nil, let data = data, let _ = response as? HTTPURLResponse {
                
                do {
                    let response = response as? HTTPURLResponse
                    if response?.statusCode == 200 {
                        self.attendances = try JSONDecoder().decode(Attendances.self, from: data)
                    } else {
                        self.getNewAttendance(year: year, month: month)
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
    
    // 新しい勤怠リストを取得
    func getNewAttendance(year: String, month: String){
        
        let url = URL(string: "http://127.0.0.1:5000/api/attendances/new/\(year)/\(month)/")
        let request = URLRequest(url: url!)
            
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
              
            if error == nil, let data = data, let _ = response as? HTTPURLResponse {
                
                do {
                    let response = response as? HTTPURLResponse
                    if response?.statusCode == 200 {
                        self.attendances = try JSONDecoder().decode(Attendances.self, from: data)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
           return 1
    }
    
    // セルの数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendances.attendances?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 勤怠セル取得
        attendanceCell = (tableView.dequeueReusableCell(withIdentifier: "attendanceCell", for: indexPath) as? AttendanceTableViewCell)!
        
        let attendancesList = attendances.attendances
        
        // 日付取得　エラー時は創業日を入れてる
        let date = String(attendancesList?[indexPath.row].date.suffix(5) ?? "2011-06-17").split(separator: "-")
            
        attendanceCell.dayLabel.text = String(date.first! + "/" + date.last!)
        
        attendanceCell.weekdayLabel.text = attendancesList?[indexPath.row].weekday
        
        attendanceCell.summaryText.text = attendancesList?[indexPath.row].summary
        
        let start_time = f.date(from: (attendancesList?[indexPath.row].start_time) ?? "00:00")
        
        let end_time = f.date(from: (attendancesList?[indexPath.row].end_time) ?? "00:00")
        
        let rest_time = f.date(from: (attendancesList?[indexPath.row].rest_time) ?? "00:00")
        
        let work_time = f.date(from: (attendancesList?[indexPath.row].work_time) ?? "00:00")
        
        attendanceCell.startTimePicker.date = start_time!
        
        attendanceCell.endTimePicker.date = end_time!
        
        attendanceCell.restTimePicker.date = rest_time!
        
        attendanceCell.workTimePicker.date = work_time!
        
        return attendanceCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {// 選択したセル取得
        attendanceCell = (tableView.cellForRow(at: indexPath) as? AttendanceTableViewCell)!
        attendanceCell.startTimePicker.isUserInteractionEnabled = true
        attendanceCell.endTimePicker.isUserInteractionEnabled = true
        attendanceCell.restTimePicker.isUserInteractionEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // 選択したセル取得
        let cell = (tableView.cellForRow(at: indexPath) as? AttendanceTableViewCell)!
        
        cell.startTimePicker.isUserInteractionEnabled = false
        cell.endTimePicker.isUserInteractionEnabled = false
        cell.restTimePicker.isUserInteractionEnabled = false
    }
    
    // pickerの列の数
    func numberOfComponents(in yearsMonthsPicker: UIPickerView) -> Int {
        return 2
    }
    
    // pickerに表示する値の数
    func pickerView(_ yearsMonthsPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return years.count
        case 1:
            return months.count
        default:
            return 0
        }
    }
    
    
     //pickerに表示する値を返すデリゲートメソッド.
    func pickerView(_ yearsMonthsPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return years[row]
        case 1:
            return months[row]
        default:
            return "error"
        }
    }
    
    // pickerが選択された際に呼ばれるデリゲートメソッド.
    func pickerView(_ yearsMonthsPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year  = years[yearsMonthsPicker.selectedRow(inComponent: 0)]
        let month = months[yearsMonthsPicker.selectedRow(inComponent: 1)]
        getAttendances(year: year,month: month)
    }
    
    
    @IBAction func changedSummaryText(_ sender: Any) {
        let attendancesList = attendances.attendances
        let indexPath = tableView!.indexPathForSelectedRow!
        let cell = tableView.cellForRow(at: indexPath) as! AttendanceTableViewCell
        attendancesList?[indexPath.row].summary =  cell.summaryText!.text!
    }
    
    @IBAction func changedStartTimePicker(_ sender: Any) {
        let attendancesList = attendances.attendances
        let indexPath = tableView!.indexPathForSelectedRow!
        let cell = tableView.cellForRow(at: indexPath) as! AttendanceTableViewCell
        attendancesList?[indexPath.row].start_time = f.string(from: cell.startTimePicker.date)
        
        changeWorkTime()
    }
    
    @IBAction func changedEndTimePicker(_ sender: Any) {
        let attendancesList = attendances.attendances
        let indexPath = tableView!.indexPathForSelectedRow!
        let cell = tableView.cellForRow(at: indexPath) as! AttendanceTableViewCell
        attendancesList?[indexPath.row].end_time = f.string(from: cell.endTimePicker.date)
        
        changeWorkTime()
    }
    
    
    @IBAction func changedRestTimePicker(_ sender: Any) {
        let attendancesList = attendances.attendances
        let indexPath = tableView!.indexPathForSelectedRow!
        let cell = tableView.cellForRow(at: indexPath) as! AttendanceTableViewCell
        attendancesList?[indexPath.row].rest_time = f.string(from: cell.restTimePicker.date)
        
        changeWorkTime()
    }
    
    func changeWorkTime() {
        let attendancesList = attendances.attendances
        let indexPath = tableView!.indexPathForSelectedRow!
        let cell = tableView.cellForRow(at: indexPath) as! AttendanceTableViewCell
        
        let start_time_arr = attendancesList?[indexPath.row].start_time.split(separator: ":")
        let end_time_arr = attendancesList?[indexPath.row].end_time.split(separator: ":")
        let rest_time_arr = attendancesList?[indexPath.row].rest_time.split(separator: ":")
        
        // StringはsplitされたらSubStringとなる
        // IntにするためにはSubString -> String -> Int と変換する必要があるためこのようにしている
        let start_time_num = (Int(String(start_time_arr?.first ?? "0"))! * 60) + (Int(String(start_time_arr?.last ?? "0"))!)
        
        let end_time_num = (Int(String(end_time_arr?.first ?? "0"))! * 60) + (Int(String(end_time_arr?.last ?? "0"))!)
        
        let rest_time_num = (Int(String(rest_time_arr?.first ?? "0"))! * 60) + (Int(String(rest_time_arr?.last ?? "0"))!)
        
        let work_time_num = Float(end_time_num - start_time_num - rest_time_num)
        
        let work_time_hour = floorf(work_time_num / 60)
        
        var work_time_min = work_time_num - (work_time_hour * 60)
        
        // マイナスの場合
        if (work_time_min < 0 ) {
            work_time_min = 60 + work_time_min
        }
        
        let work_time = String(Int(work_time_hour)) + ":" + String(Int(work_time_min))
        
        attendancesList?[indexPath.row].work_time = work_time
        
        cell.workTimePicker.date = f.date(from: work_time)!
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        // 勤怠オブジェクトをjsonへ変換
        let encoder = JSONEncoder()
        let attendances_json = try! encoder.encode(attendances.attendances)
        
        // request
        let url = URL(string: "http://127.0.0.1:5000/api/attendances/")
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = attendances_json
        
        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in
              
            if error == nil, let _ = data, let _ = response as? HTTPURLResponse {
                let response = response as? HTTPURLResponse
                if response?.statusCode == 200 {
                    //self.getAttendances(year: "2019",month: "6")
                    self.saved = true
                    // データ取得後にテーブル再描画
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
                    }
                    
                }
            }
        }
        // 通信開始
        task.resume()
    }
}
