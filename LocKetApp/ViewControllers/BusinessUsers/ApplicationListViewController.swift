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
print("cellForRowAt")
        
        // style
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.systemGray5.cgColor
        cell.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        
        let seller = sellers[indexPath.row]
        
        
        // UITableView 오브젝트 세팅
        
        // (1) 라벨
        let lblName = cell.viewWithTag(2) as? UILabel
        let lblCategory = cell.viewWithTag(3) as? UILabel
        let lblSNS = cell.viewWithTag(4) as? UILabel
        let txtViewDescription = cell.viewWithTag(5) as? UITextView
        let btn = cell.viewWithTag(6) as? UIButton
        
        if let index = markets.firstIndex(where: { $0._id == seller.marketId }){
            let marketName = markets[index].name
            lblName?.text = marketName
        }
        lblCategory?.text = seller.category + " > " + seller.subCategory
        lblSNS?.text = seller.sns.joined(separator: ", ")
        txtViewDescription?.text = seller.description
        btn?.setTitle(seller.state, for: .normal)
        btn?.tag = indexPath.row
        btn?.addTarget(self, action: #selector(stateTapped(_:)), for: .touchUpInside)
        
        
        // (2) 이미지
        // 사진 파일이 있으면 애저 스트로지에서 가져오기
        let imageView = cell.viewWithTag(1) as? UIImageView
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
                        self.tableView.reloadData()
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
