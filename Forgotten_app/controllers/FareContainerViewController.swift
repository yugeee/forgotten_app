//
//  FareContainerViewController.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2020/01/08.
//  Copyright © 2020 弓削直樹. All rights reserved.
//

import UIKit

class FareContainerViewController: UIViewController {

    // DatePickerに時間を入れるためDate型にする
    // フォーマッタの用意
    let f = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        f.timeStyle = .short
        f.dateStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "yyyy-MM-dd"
    }
    

    @IBAction func pushedAddButton(_ sender: Any) {
        let parentVC = self.parent as! FareTableViewController

        var fareList = parentVC.fares.fares
        let new_fare = Fare()
        
        let date = f.string(from: Date())
        
        new_fare.date = date
        
        fareList?.append(new_fare)
        
        parentVC.updateTable(fareList: fareList!, saved: false)
    }
    
    @IBAction func pushedSaveButton(_ sender: Any) {
        
        let parentVC = self.parent as! FareTableViewController

        let fareList = parentVC.fares.fares
        
        // 運賃オブジェクトをjsonへ変換
        let encoder = JSONEncoder()
        let fares_json = try! encoder.encode(fareList)
            
        // request
        let url = URL(string: "http://127.0.0.1:5000/api/fares/")
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = fares_json
            
        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in
                  
            if error == nil, let _ = data, let _ = response as? HTTPURLResponse {
                let response = response as? HTTPURLResponse
                    if response?.statusCode == 200 {
                }
            }
            // データ取得後にテーブル再描画
            DispatchQueue.main.async {
                parentVC.updateTable(fareList: fareList!, saved: true)
            }
        }
        // 通信開始
        task.resume()
        
    }
}
