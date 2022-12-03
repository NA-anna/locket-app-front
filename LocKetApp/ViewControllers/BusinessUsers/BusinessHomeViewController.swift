//
//  BusinessHomeViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/24.
//

import UIKit

class BusinessHomeViewController: UIViewController {

    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "marketprofile")
    
    
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "marketcell", for: indexPath)
        
        
        let market = markets[indexPath.row]
        
        // UITableView 오브젝트
        // (1) 이미지
        // 사진 파일이 있으면 애저 스트로지에서 가져오기
        if market.photo.count > 0 {
            let blobName = market.photo[0]
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
        // (2) 라벨
        let lblTitle = cell.viewWithTag(2) as? UILabel
        lblTitle?.text = market.name
        // (3) 버튼
        let today = Date().toString()
        guard let sellersForm = market.sellersForm else { return cell }
        let btn = cell.viewWithTag(3) as? UIButton
        if market.needSellers && sellersForm.deadline > today { //모집중 마켓
            btn?.isHidden = false
        }else {
            btn?.isHidden = true
        }
        

        return cell
    }
    
    
}
