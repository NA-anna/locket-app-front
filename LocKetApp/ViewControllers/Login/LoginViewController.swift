//
//  LoginViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/21.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        ProgressHUD.dismiss()
    }
    // 빈 화면 터치 시 키보드 내려가기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction func actLogin(_ sender: UIButton) {
        
        
        
        ProgressHUD.show()
        
        
        
        // User Login
        if segment.selectedSegmentIndex == 0 {
            
            getLoginUser(id: "heungmin7") { isOK in
                if isOK {

                    //---------------데이터 가져오기 작업---------------
                    // (1) 플리마켓 데이터 가져오기
                    getMarkets {
                        // (2) 5일장 데이터 가져와서 합치기 fiveMarkets -> fiveMarkets (for Map)
                        //var combinedFiveMarkets: [Item] = []
                        get5Markets( numOfRows: 150, type: "5일장") {
                            // 화면전환
                            self.performSegue(withIdentifier: "user", sender: nil)
              
                        }
                    }
                    
                    
                    

                }else {
                    
                    let alert = UIAlertController(title: "등록된 회원이 아닙니다", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                
                }
            }
           
        // Businessuser Login
        }else {
            
            getLoginBusinessuser(id: "iseoulu") { isOK in
                if isOK {
                    
                    //---------------데이터 가져오기 작업---------------
                    guard let businessuser = businessuser else {return}
                    getMarketsOfBusinessuser(businessuserId: businessuser.id) {
                        
                        // 화면전환
                        self.performSegue(withIdentifier: "businessuser", sender: nil)
                    }
                    
                    
                }else {
                    
                    let alert = UIAlertController(title: "등록된 회원이 아닙니다", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    
                }
            }
            
            
        }
  
    }
}




