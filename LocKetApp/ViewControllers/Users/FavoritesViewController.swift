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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let user = user else { return 0 }
        if section == 0 {
            return user.favorites.fav_fleamarkets.count
        }else {
            return user.favorites.fav_fivemarkets.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritescell", for: indexPath)

        guard let user = user else { return cell }
        
        let lblTitle = cell.viewWithTag(1) as? UILabel
        if indexPath.section == 0 {
            lblTitle?.text = user.favorites.fav_fleamarkets[indexPath.row].market_id
        }else {
            lblTitle?.text = user.favorites.fav_fivemarkets[indexPath.row].market_name
        }

        return cell
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
