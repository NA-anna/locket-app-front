//
//  AppliedListViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/27.
//

import UIKit

class AppliedListViewController: UITableViewController {
    
    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "sellerprofile")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 내가 신청한 셀러 목록
        guard let user = user else {return}
        let userId = user.id
        getSellersByUser(userId: userId) {
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
        let lblName = cell.viewWithTag(2) as? UILabel
        let lblCategory = cell.viewWithTag(3) as? UILabel
        let lblSNS = cell.viewWithTag(4) as? UILabel
        let txtViewDescription = cell.viewWithTag(5) as? UITextView
        let lblState = cell.viewWithTag(6) as? UILabel
        
        if let index = markets.firstIndex(where: { $0._id == seller.marketId }){
            let marketName = markets[index].name
            lblName?.text = marketName
        }
        lblCategory?.text = seller.category + " > " + seller.subCategory
        lblSNS?.text = seller.sns.joined(separator: ", ")
        txtViewDescription?.text = seller.description
        lblState?.text = seller.state
        
        // (2) 이미지
        // 사진 파일이 있으면 애저 스트로지에서 가져오기
        let imageView = cell.viewWithTag(1) as? UIImageView
        imageView?.layer.cornerRadius = 5.0
        if seller.photo.count > 0 {
            let blobName = seller.photo[0]
            if blobName != "" {
                blobstorage.downloadImage(blobName: blobName, handler: { data in
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        imageView?.image = image
                    }
                })
            }
        // 사진 파일이 없으면 디폴트 이미지
        }else {
            imageView?.image = UIImage(named: "rocket_up")
        }

        
        
        
        
        

        return cell
    }
    



    

}
