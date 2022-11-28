//
//  FleaMarketsViewController.swift
//  LocketApp
//
//  Created by 나유진 on 2022/11/20.
//
  
import UIKit

class FleaMarketsViewController: UITableViewController {

    // 장날보기|모집중 세그먼트
    @IBOutlet var segCon: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        //마켓 데이터 가져오기
//        getMarkets {
//            self.tableView.reloadData()
//        }
    }

    
    // 세그먼트 변경 액션
    var filtered = markets
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        
       //모집중
        if segCon.selectedSegmentIndex == 1 {
            filtered = markets.filter { market in
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
            return filtered.count
            
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marketscell", for: indexPath)

        // 악세사리
        cell.accessoryType = .disclosureIndicator //UIImageView(image: UIImage(systemName: "heart"))
        
        
        var market = markets[indexPath.row]
        if segCon.selectedSegmentIndex == 1 {
            market = filtered[indexPath.row]
        }
        
        // TABLE VIEW 에 값 지정
        let lblTitle = cell.viewWithTag(1) as? UILabel
        lblTitle?.text = market.name
        let lblCategory = cell.viewWithTag(2) as? UILabel
        lblCategory?.text = market.category
        let lblPlace = cell.viewWithTag(3) as? UILabel
        lblPlace?.text = "장소: \(market.place)"
        let lblDate = cell.viewWithTag(4) as? UILabel
        lblDate?.text = "\(market.startdate) ~ \(market.enddate)"
        let lblDescription = cell.viewWithTag(5) as? UILabel
        lblDescription?.text = market.description


        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? FleaMarketDetailViewController
        if let index = tableView.indexPathForSelectedRow?.row {
            vc?.market = markets[index]
            vc?.isGathering = (segCon.selectedSegmentIndex == 1) //모집중이면 True
        }
    }


}
