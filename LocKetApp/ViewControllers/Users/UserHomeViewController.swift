//
//  UserHomeViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/24.
//

import UIKit

class UserHomeViewController: UIViewController {

    @IBOutlet var lblHello: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {return}
        let name = user.name
        lblHello.text = "\(name)님, \n안녕하세요"
    }
    
    // 빈 화면 터치 시 키보드 내려가기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
    }
    

}
