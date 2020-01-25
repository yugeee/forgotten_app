//
//  FareMasterContainerViewController.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2020/01/11.
//  Copyright © 2020 弓削直樹. All rights reserved.
//

import UIKit

class FareMasterContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func pushedAddButton(_ sender: Any) {
        let parentVC = self.parent as! FareMasterTableViewController

        let new_fare_master = FareMaster()
        
        var fare_masters = parentVC.fare_masters
        
        fare_masters.append(new_fare_master)
        
        parentVC.updateTable(fare_masters: fare_masters)
    }
    
    
    @IBAction func pushedSaveButton(_ sender: Any) {
        let parentVC = self.parent as! FareMasterTableViewController
        
        let fare_masters = parentVC.fare_masters
        
        // 運賃マスタオブジェクトをjsonへ変換
        let encoder = JSONEncoder()
        let fare_masters_json = try! encoder.encode(fare_masters)
        
        // request
        let url = URL(string: "http://127.0.0.1:5000/api/fare_masters/")
        var request = URLRequest(url: url!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = fare_masters_json
        
        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in
                      
            if error == nil, let _ = data, let _ = response as? HTTPURLResponse {
                let response = response as? HTTPURLResponse
                    if response?.statusCode == 200 {
                }
            }
            // データ取得後にテーブル再描画
            DispatchQueue.main.async {
                parentVC.updateTable(fare_masters: fare_masters)
            }
        }
        // 通信開始
        task.resume()
    }
}
