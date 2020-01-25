//
//  SubmitViewController.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2020/01/13.
//  Copyright © 2020 弓削直樹. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var yearsMonthsPicker: UIPickerView!
    
    let years:[String] = ["2019","2020"]
    let months:[String] = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
    
    @IBAction func pushedSubmitButton(_ sender: Any) {
        
        let year  = years[yearsMonthsPicker.selectedRow(inComponent: 0)]
        let month = months[yearsMonthsPicker.selectedRow(inComponent: 1)]
        
        // request
        let url = URL(string: "http://127.0.0.1:5000/api/submit/\(year)/\(month)/")
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
                
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
    }
    

}
