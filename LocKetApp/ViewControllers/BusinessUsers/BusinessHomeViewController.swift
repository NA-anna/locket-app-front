//
//  BusinessHomeViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/24.
//

import UIKit

class BusinessHomeViewController: UIViewController { 
    
    
    @IBOutlet var lblHello: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        guard let businessuser = businessuser else {return}
        
    
        // 오브젝트 세팅
        let name = businessuser.name
        lblHello.text = "\(name)님, \n안녕하세요. \n등록된 마켓내역을 확인하세요."
        
        // UITableView 프로토콜
        tableView.dataSource = self
        tableView.delegate = self
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension BusinessHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        markets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "marketcell", for: indexPath) as? MarketCell else { return UITableViewCell() }
        
        
        let market = markets[indexPath.row]
        cell.setValues(market: market, index : indexPath.row)
          
        

        return cell
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as? ApplicationListViewController
        
        if let tag = (sender as? UIButton)?.tag {
            print(tag)
            vc?.market = markets[tag]
        }
    }
}


