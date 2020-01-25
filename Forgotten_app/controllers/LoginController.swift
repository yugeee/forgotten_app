//
//  LoginController.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2019/07/18.
//  Copyright © 2019 弓削直樹. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    var user :LoginUser = LoginUser()
    
    @IBOutlet weak var idInput: UITextField!
    @IBOutlet weak var pwInput: UITextField!
    @IBOutlet weak var msgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapLoginButton(_ sender: Any) {
        guard let id: String = idInput.text else {
            // 入力なし
            return
        }
        guard let pw: String = pwInput.text else {
            // 入力なし
            return
        }
        
        let url = URL(string: "http://127.0.0.1:5000/api/login/")
        var request = URLRequest(url: url!)
        // POSTを指定
        request.httpMethod = "POST"
        
        // POSTするデータをBodyとして設定
        request.httpBody = "id=\(id)&pass=\(pw)".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                
                do {
                    
                    if response.statusCode == 400 {
                        if let res = String(data: data, encoding: String.Encoding.utf8) {
                            self.msgLabel.text = res
                        }
                    }
                    
                    if response.statusCode == 404 {
                        if let res = String(data: data, encoding: String.Encoding.utf8) {
                            self.msgLabel.text = res
                        }
                    }
                
                    if response.statusCode == 200 {
                        
                        if let fields = response.allHeaderFields as? [String: String], let url = response.url {
                            for cookie in HTTPCookie.cookies(withResponseHeaderFields: fields, for: url) {
                                HTTPCookieStorage.shared.setCookie(cookie)
                            }
                        }
                        
                        self.user = try JSONDecoder().decode(LoginUser.self, from: data)
                        self.performSegue(withIdentifier: "login_exec", sender: nil)
                        
                    }
                    
                } catch let error {
                    print("## error: \(error)")
                }
                
                
            }
        }
            
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if self.user.id != "" {
            let viewController = segue.destination as! MainMenuViewController
        
            viewController.user = self.user
        }
    }
}
