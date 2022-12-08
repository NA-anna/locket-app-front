//
//  5MarketsViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/22.
//
  
import UIKit

class FiveMarketsViewController: UITableViewController {

    var pFiveMarkets = fiveMarkets //필터링 후 이 페이지에서만 사용되는 프라이빗 배열
    
    @IBOutlet var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style
        self.navigationController?.navigationBar.topItem?.title = ""  // 내비게이션바 back 문구 지우기
    }
    @IBAction func actSegmentChanged(_ sender: Any) {
//        switch segment.selectedSegmentIndex {
//        case 0 : print(pFiveMarkets)
//        case 1:
//            self.pFiveMarkets = fiveMarkets.filter { market in
//                let idx = market.rdnmadr.index(market.rdnmadr.startIndex, offsetBy: 1)
//                //let place = market.rdnmadr[...idx]
//                print(idx)
//                return true //place == "서울"
//            }
//        default: print(pFiveMarkets)
//        }
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


