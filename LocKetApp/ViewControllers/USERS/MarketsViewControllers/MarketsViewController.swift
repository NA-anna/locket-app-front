//
//  MarketsViewController.swift
//  LocketApp
//
//  Created by 나유진 on 2022/11/20.
//
  
import UIKit

class MarketsViewController: UITableViewController {


    var category = "플리마켓" //카테고리
    var pMarkets = markets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style
        self.navigationController?.navigationBar.topItem?.title = ""  // 내비게이션바 back 문구 지우기
        
        
        // 카테고리에 따라서 마켓 필터
        self.pMarkets = markets.filter { market in
            return market.category == self.category
        }
        
        
    }
    
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pMarkets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "marketcell", for: indexPath) as? MarketsCell else { return UITableViewCell() }
        
        let market = pMarkets[indexPath.row]
        
        cell.setValues(market: market, index : indexPath.row)

        return cell
    }
    

 
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? MarketDetailViewController
        
        
        if let index = tableView.indexPathForSelectedRow?.row {
            
            vc?.market = pMarkets[index]
            
        }
    }


}
