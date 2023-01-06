//
//  LoginViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/21.
//

import UIKit
import AuthenticationServices
import ProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var signInView: UIView!
    @IBOutlet var btnApple: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addButton()
          
        btnApple.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
    }
    // 화면 닫힐 때 -> ProgressHUD 닫기
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
                self.userLogin(isOK)
            }
           
        // Businessuser Login
        }else {
            
            getLoginBusinessuser(id: "iseoulu") { isOK in
                self.businessuserLogin(isOK)
            }
        }
    }
    
    func userLogin(_ isOK: Bool) {
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
    
    func businessuserLogin(_ isOK: Bool) {
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
/*
    // apple signIn button 추가
    func addButton() {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        signInView.addSubview(button)
    }
 */
    @objc func loginHandler() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }

    
}





extension LoginViewController : ASAuthorizationControllerDelegate  {
    // Success
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("👨‍🍳 \(credential.user)")
            
//            if let identityToken = credential.identityToken {}
            
            // 처음에는 이메일과 풀네임 제공 그 다음부터는 제공 x
            // 분기 필요
            // -이메일 있으면 -> 신규 사용자 -> 데이터 추가
            // -이메일 없으면 -> 기존 사용자
            if let email = credential.email, email != "",
               let authorizationCode = credential.authorizationCode,
               let fullName = credential.fullName, let familyName = fullName.familyName, let givenName = fullName.givenName{
                
                print("✉️ \(email)")
                print("🔐 \(authorizationCode)")
                print("😀 \(fullName)")
                
              
                let bodyData : [String: Any]
                = [ "id": credential.user,
                    "loginPw": "",
                    "name": familyName+givenName,
                    "profile": "",
                    "tel": "",
                    "email": email,
                    "favorites": []
                ]
                print(bodyData)
                postUser(body: bodyData){
                    getLoginUser(id: credential.user) { isOK in
                        self.userLogin(isOK)
                    }
                }
            // 000131.2b9dc317df69499eb2c79ef1f705d2d1.0451
            // 000131.2b9dc317df69499eb2c79ef1f705d2d1.0451
            }else {

                getLoginUser(id: credential.user) { isOK in
                    self.userLogin(isOK)
                }
            }
            
            
            
        }
    }
    // Fail
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error \(error)")
        
        //apple 로그인 실패
        userLogin(false)
    }
}
