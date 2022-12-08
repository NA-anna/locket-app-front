//
//  5MarketsViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/22.
//
  
import UIKit

class FiveMarketsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style
        self.navigationController?.navigationBar.topItem?.title = ""  // 내비게이션바 back 문구 지우기
    }
    

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveMarkets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fivemarketcell", for: indexPath) as? FiveMarketCell else { return UITableViewCell() }
        
        let market = fiveMarkets[indexPath.row]
        cell.setValues(market: market, index : indexPath.row)

        return cell
    }

    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? FiveMarketDetailViewController
        if let index = tableView.indexPathForSelectedRow?.row {
            vc?.fiveMarket = fiveMarkets[index]
        }
    }
    

}


