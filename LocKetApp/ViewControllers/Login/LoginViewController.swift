//
//  LoginViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    

    
    @IBAction func actLogin(_ sender: UIButton) {
        
        
        
        
        // User Login
        if segment.selectedSegmentIndex == 0 {
            
            getLoginUser(id: "heungmin7") { flag in
                if flag {

                    self.performSegue(withIdentifier: "user", sender: nil)
                    
                }else {
                    
                    let alert = UIAlertController(title: "등록된 회원이 아닙니다", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                
                }
            }
           
        // Businessuser Login
        }else {
            
            getLoginBusinessuser(id: "iseoulu") { flag in
                if flag {
                    
                    self.performSegue(withIdentifier: "businessuser", sender: nil)
                    
                }else {
                    
                    let alert = UIAlertController(title: "아닙니다", message: "아닙니다", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ㅇㅇ", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    
                }
            }
            
            
        }
  
    }
}

