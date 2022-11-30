//
//  AddViewController_category.swift
//  miniProject_map
//
//  Created by 나유진 on 2022/10/27.
//

import UIKit

class AddViewController_category: UITableViewController {

    var parentVC: AddViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let category = gSellerCategories[indexPath.row]
        
        if let parentVC = self.parentVC {
            print("데이터 전송 to parent")
            parentVC.categories = category
            dismiss(animated: true)
        }
        
    }
}
