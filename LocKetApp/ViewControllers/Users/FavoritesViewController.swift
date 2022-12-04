//
//  FavoritesViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/23.
//

import UIKit

class FavoritesViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        guard let user = user else { return 0 }
        if section == 0 {
            return user.favorites.fav_fleamarkets.count
        }else {
            return user.favorites.fav_fivemarkets.count
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "플리마켓"
        }else {
            return "5일장"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritescell", for: indexPath)

        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.systemGray4.cgColor

        
        let tableIndex = indexPath.row
        guard let user = user else { return cell }
        
        // 테이블 오브젝트
        let lblTitle = cell.viewWithTag(1) as? UILabel
        
        // 플리마켓
        if indexPath.section == 0 {
            if let index = markets.firstIndex(where: { $0._id == user.favorites.fav_fleamarkets[tableIndex].market_id }){
                let marketName = markets[index].name
                lblTitle?.text = marketName
            }
        // 5일장
        }else {
            lblTitle?.text = user.favorites.fav_fivemarkets[tableIndex].market_name
        }

        return cell
    }

    


}
