//
//  BusinessHomeViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/24.
//

import UIKit

class BusinessHomeViewController: UIViewController {

    @IBOutlet var lblHello: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let businessuser = businessuser else {return}
        let name = businessuser.name
        lblHello.text = "\(name)님, \n안녕하세요"
    
    }
    



}
