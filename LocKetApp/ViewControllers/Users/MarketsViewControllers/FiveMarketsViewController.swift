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
        
        get5Markets(numOfRows: 10, type: "상설장+5일장") {
            self.tableView.reloadData()
        }
    }
    
    // 세그먼트 변경 액션 
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            get5Markets( numOfRows: 10, type: "상설장+5일장") {
                self.tableView.reloadData()
            }
        }else {
            get5Markets( numOfRows: 10, type: "5일장") {
                self.tableView.reloadData()
            }
        }
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


