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
        
        //마켓 데이터 가져오기
        getMarkets {
            self.tableView.reloadData()
        }
        
        //셀러 신청한 데이터 가져오기
        guard let user = user else {return}
        let userId = user.id
        getSeller(userId: userId) {
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

        let seller = sellers[indexPath.row]
        
        let blobName = seller.photo[0]
        print(blobName)
        if blobName != "" {
            
            blobstorage.downloadImage(blobName: blobName, handler: { data in
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    let imageView = tableView.viewWithTag(1) as? UIImageView
                    imageView?.image = image
                }
            })
        }
        
        let lblName = tableView.viewWithTag(2) as? UILabel
        lblName?.text = seller.marketId
        

        return cell
    }
    



    

}
