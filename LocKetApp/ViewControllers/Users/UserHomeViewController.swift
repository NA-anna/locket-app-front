//
//  UserHomeViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/24.
//

import UIKit

class UserHomeViewController: UIViewController {

    @IBOutlet var lblHello: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {return}
        let name = user.name
        lblHello.text = "\(name)님, \n안녕하세요"
    }
    

}
