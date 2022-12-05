//
//  ApplicationListViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/12/04.
//

import UIKit

class ApplicationListViewController: UITableViewController {
    

    
    var market: Market?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 신청된 셀러 목록
        guard let market = market, let marketId = market._id else {return}
        getSellersByMarket(marketId: marketId) {
            self.tableView.reloadData()
        }
    
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sellercell", for: indexPath) as? SellerCell else { return UITableViewCell() }
        
        // style
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.systemGray5.cgColor
        cell.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        
        let seller = sellers[indexPath.row]
        cell.setValues(seller: seller, index : indexPath.row)
        
        // 타겟 지정
        cell.btn.addTarget(self, action: #selector(stateTapped(_:)), for: .touchUpInside)
    
        
               

        return cell
    }
    
    

    @objc func stateTapped(_ sender: UIButton){
        
        let alert = UIAlertController(title: "", message: "선택하시면 신청상태가 변경됩니다.", preferredStyle: .actionSheet)
        for item in gSellerApplicationState {
            let action = UIAlertAction(title: item, style: .default) {_ in
                print("API 호줄")
                
                var seller = sellers[sender.tag]
                seller.state = item
                
                // 데이터 인코딩
                let jsonData: Data = try! JSONEncoder().encode(seller)
                guard let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {return}
                
                // PUT
                guard let sellerId = seller._id else {return}
                putSellerData( id: sellerId, body: jsonDictionary ){ statusCode in
                    if statusCode <= 204 {
//                        self.tableView.reloadData()
//                        // GET (재조회)
//                        // 신청된 셀러 목록
//                        guard let market = self.market, let marketId = market._id else {return}
//                        getSellersByMarket(marketId: marketId) {
//                            self.tableView.reloadData()
//                        }
                    }
                }
            }
            alert.addAction(action)
        }
        let actionCancle = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(actionCancle)
        self.present(alert, animated: true)
    }
 
}
