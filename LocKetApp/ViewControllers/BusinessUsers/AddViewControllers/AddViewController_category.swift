//
//  AddViewController_category.swift
//  miniProject_map
//
//  Created by 나유진 on 2022/10/27.
//

import UIKit

class AddViewController_category: UITableViewController {

    var parentVC: AddViewController?
    //var sellerCategories: [String] = gSellerCategories
    var arrCheck: [Bool] = [Bool](repeating: false, count: gSellerCategories.count)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let parentVC = self.parentVC {
            parentVC.arrCheck = arrCheck
            print("데이터 전송 to parent")
    
        }
    }

    
     
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gSellerCategories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categorycell", for: indexPath)

        let lblCategory = cell.viewWithTag(1) as? UILabel
        lblCategory?.text = gSellerCategories[indexPath.row]
        let btnCheck = cell.viewWithTag(2) as? UIButton
        btnCheck?.isHidden = !arrCheck[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrCheck[indexPath.row].self.toggle()
        tableView.reloadData()
    }
}
