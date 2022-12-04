//
//  ApplicationListViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/12/04.
//

import UIKit

class ApplicationListViewController: UITableViewController {
    
    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "sellerprofile")
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath)

        
        // style
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.systemGray5.cgColor
        cell.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        
        let seller = sellers[indexPath.row]
        
        
        // UITableView 오브젝트
        
        // (1) 라벨
        if let index = markets.firstIndex(where: { $0._id == seller.marketId }){
            let marketName = markets[index].name
            
            let lblName = cell.viewWithTag(2) as? UILabel
            lblName?.text = marketName
        }
    
        let lblCategory = cell.viewWithTag(3) as? UILabel
        lblCategory?.text = seller.category + " > " + seller.subCategory
        
        let lblSNS = cell.viewWithTag(4) as? UILabel
        lblSNS?.text = seller.sns.joined(separator: ", ")
        
        let txtViewDescription = cell.viewWithTag(5) as? UITextView
        txtViewDescription?.text = seller.description

        let lblState = cell.viewWithTag(6) as? UILabel
        lblState?.text = seller.state
        
        // (2) 이미지
        // 사진 파일이 있으면 애저 스트로지에서 가져오기
        if seller.photo.count > 0 {
            let blobName = seller.photo[0]
            if blobName != "" {
                blobstorage.downloadImage(blobName: blobName, handler: { data in
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        let imageView = cell.viewWithTag(1) as? UIImageView
                        imageView?.image = image
                    }
                })
            }
        // 사진 파일이 없으면 디폴트 이미지
        }else {
            let imageView = cell.viewWithTag(1) as? UIImageView
            imageView?.image = UIImage(named: "rocket_up")
        }

        
        
        
        
        

        return cell
    }
    

}