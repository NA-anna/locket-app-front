//
//  MypageViewController.swift
//  LocKetApp
//
//  Created by yeonji on 2022/11/26.
//

import UIKit

class MypageViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var nickName: UILabel!
    @IBOutlet var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        
        guard let user = user else {return}
        let name = user.name
        nickName.text = "\(name)"
        
        let email = user.email
        userEmail.text = "\(email)"
        
    }
    


}
extension MypageViewController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let symbol = cell.viewWithTag(1) as? UIImageView
        let label = cell.viewWithTag(2) as? UILabel
        
        switch indexPath.row{
        case 0:
            symbol?.image = UIImage(systemName: "bell")
            symbol?.tintColor = .label
            label?.text = "나의 신청 마켓!!!!!!"
            
        case 1:
            symbol?.image = UIImage(systemName: "heart")
            symbol?.tintColor = .label
            label?.text = "관심목록"
            
        case 2:
            symbol?.image = UIImage(systemName: "questionmark.circle")
            symbol?.tintColor = .label
            label?.text = "고객센터"
            
        case 3:
            symbol?.image = UIImage(systemName: "ipad.and.arrow.forward")
            symbol?.tintColor = .label
            label?.text = "로그아웃"
            
        default:
            print("디폴트~")
        }
        return cell
    }
    
    
    
}
