//
//  AttendanceMasterViewController.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2019/11/21.
//  Copyright © 2019 弓削直樹. All rights reserved.
//

import UIKit

class AttendanceMasterViewController: UIViewController {
    
    var attendance_master :AttendanceMaster = AttendanceMaster()
    
    @IBOutlet weak var summaryText: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var restTimePicker: UIDatePicker!
    @IBOutlet weak var workTimePicker: UIDatePicker!
    
    @IBOutlet weak var savedLabel: UILabel!
    // DatePickerに時間を入れるためDate型にする
    // フォーマッタの用意
    let f = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        f.timeStyle = .short
        f.dateStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        
        getAttendanceMaster()
        // Do any additional setup after loading the view.
    }
    
    // 勤怠マスタ情報をUIに表示
    override func viewDidAppear(_ animated: Bool) {
        setAttendanceMaster()
    }
    
    func getAttendanceMaster() {
        
        let url = URL(string: "http://127.0.0.1:5000/api/attendance_master")
        let request = URLRequest(url: url!)
            
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
              
            if error == nil, let data = data, let _ = response as? HTTPURLResponse {
                
                do {
                    let response = response as? HTTPURLResponse
                    if response?.statusCode == 200 {
                        
                        self.attendance_master = try JSONDecoder().decode(AttendanceMaster.self, from: data)
                    } else {
                        
                    }
                } catch let error {
                    print("## error: \(error)")
                }
            }
        }
        // 通信開始
        task.resume()
    }
    
    func setAttendanceMaster() {
        let start_time = f.date(from: attendance_master.start_time)
        let end_time = f.date(from: attendance_master.end_time)
        let rest_time = f.date(from: attendance_master.rest_time)
        let work_time = f.date(from: attendance_master.work_time)
        
        summaryText.text = attendance_master.summary
        startTimePicker.date = start_time!
        endTimePicker.date = end_time!
        restTimePicker.date = rest_time!
        workTimePicker.date = work_time!
    }
    
    
    @IBAction func changedSummaryText(_ sender: Any) {
        attendance_master.summary = summaryText.text!
    }
    
    
    @IBAction func changedStartTimePicker(_ sender: Any) {
        attendance_master.start_time = f.string(from: startTimePicker.date)
        
        changeWorkTime()
    }
    
    
    @IBAction func changedEndTimePicker(_ sender: Any) {
        attendance_master.end_time = f.string(from: endTimePicker.date)
        
        changeWorkTime()
    }
    
    @IBAction func changedRestTimePicker(_ sender: Any) {
        attendance_master.rest_time = f.string(from: restTimePicker.date)
        
        changeWorkTime()
    }
    
    // 勤務時間を変更
    func changeWorkTime() {
        let start_time_arr = attendance_master.start_time.split(separator: ":")
        
        let end_time_arr = attendance_master.end_time.split(separator: ":")
        
        let rest_time_arr = attendance_master.rest_time.split(separator: ":")
        
        let start_time_num = (Int(String(start_time_arr.first ?? "0"))! * 60) + (Int(String(start_time_arr.last ?? "0"))!)
        
        let end_time_num = (Int(String(end_time_arr.first ?? "0"))! * 60) + (Int(String(end_time_arr.last ?? "0"))!)
        
        let rest_time_num = (Int(String(rest_time_arr.first ?? "0"))! * 60) + (Int(String(rest_time_arr.last ?? "0"))!)
        
        let work_time_num = Float(end_time_num - start_time_num - rest_time_num)
        
        let work_time_hour = floorf(work_time_num / 60)
        
        var work_time_min = work_time_num - (work_time_hour * 60)
        
        // マイナスの場合
        if (work_time_min < 0 ) {
            work_time_min = 60 + work_time_min
        }
        
        let work_time = String(Int(work_time_hour)) + ":" + String(Int(work_time_min))
        
        attendance_master.work_time = work_time
        
        workTimePicker.date = f.date(from: work_time)!
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        // 勤怠オブジェクトをjsonへ変換
        let encoder = JSONEncoder()
        let attendance_master_json = try! encoder.encode(attendance_master)
        
        // request
        let url = URL(string: "http://127.0.0.1:5000/api/attendance_master/")
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = attendance_master_json
    
        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in
                
            if error == nil, let _ = data, let _ = response as? HTTPURLResponse {
                let response = response as? HTTPURLResponse
                if response?.statusCode == 200 {
                }
            }
        }
        // 通信開始
        task.resume()
        
        savedLabel.text = "保存しました"
        savedLabel.backgroundColor = UIColor.green
    }
}
