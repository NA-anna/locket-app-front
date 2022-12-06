//
//  FleaMarketsViewController.swift
//  LocketApp
//
//  Created by 나유진 on 2022/11/20.
//
  
import UIKit

class FleaMarketsViewController: UITableViewController {

    
    
    var recruitingMarkets = markets
    
    @IBOutlet var segCon: UISegmentedControl!  // 장날보기|모집중 세그먼트
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // 세그먼트 변경 액션
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
       //모집중
        if segCon.selectedSegmentIndex == 1 {
            recruitingMarkets = recruitingMarkets.filter { market in
                guard let sellersForm = market.sellersForm else { return false }
                let today = Date().toString()
                return market.needSellers && sellersForm.deadline > today
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segCon.selectedSegmentIndex == 0 {
            return markets.count
        }else {
            return recruitingMarkets.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "marketcell", for: indexPath) as? FleaMarketCell else { return UITableViewCell() }
        
        var market = markets[indexPath.row]
        if segCon.selectedSegmentIndex == 1 {
            market = recruitingMarkets[indexPath.row]
        }
        
        cell.setValues(market: market, index : indexPath.row)

        return cell
    }
    

 
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? FleaMarketDetailViewController
        
        
        if let index = tableView.indexPathForSelectedRow?.row {
            
            if segCon.selectedSegmentIndex == 0 {
                vc?.market = markets[index]
            }else {
                vc?.market = recruitingMarkets[index]
            }
            
            
            vc?.isGathering = (segCon.selectedSegmentIndex == 1) //모집중이면 True
        }
    }


}
