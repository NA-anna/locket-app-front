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
        // #warning Incomplete implementation, return the number of rows
        return fiveMarkets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fivemarketscell", for: indexPath)

        // 악세사리
        //cell.accessoryType = .disclosureIndicator //UIImageView(image: UIImage(systemName: "heart"))
        
        let market = fiveMarkets[indexPath.row]
        
        // TABLE VIEW 에 데이터 뿌리기
        let lblTitle = cell.viewWithTag(1) as? UILabel
        lblTitle?.text = market.mrktNm
//        let lblCategory = cell.viewWithTag(2) as? UILabel
//        lblCategory?.text = market.mrktEstblCycle
        let lblPlace = cell.viewWithTag(3) as? UILabel
        lblPlace?.text = "주소: \(market.rdnmadr)"
        let lblDate = cell.viewWithTag(4) as? UILabel
        lblDate?.text = market.mrktEstblCycle
        let lblDescription = cell.viewWithTag(5) as? UILabel
        lblDescription?.text = market.trtmntPrdlst
        let imageView = cell.viewWithTag(10) as? UIImageView
        imageView?.layer.cornerRadius = 20


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


