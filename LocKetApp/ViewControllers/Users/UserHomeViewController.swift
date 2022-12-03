//
//  UserHomeViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/24.
//

import UIKit

class UserHomeViewController: UIViewController {

    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "marketprofile")
    
    @IBOutlet var lblHello: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {return}
        let name = user.name
        lblHello.text = "\(name)님, \n안녕하세요"
        
        // UICollectionView 데이터
        let recruitingMarkets = markets.filter { market in
            guard let sellersForm = market.sellersForm else { return false }
            let today = Date().toString()
            return market.needSellers && sellersForm.deadline > today
        }
        
        
        
//        collectionView.dataSource = self
//        collectionView.delegate = self
        //collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 빈 화면 터치 시 키보드 내려가기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}
/*
// UICollectionView 프로토콜
extension UserHomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marketcell", for: indexPath)
        
        let market = markets[indexPath.row]
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        
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

        let lblName = cell.viewWithTag(2) as? UILabel
        lblName?.text = market.name

        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let itemSpace = 10.0
        let width =  collectionView.frame.width
        return CGSize(width: width, height: width*0.5)
    }
}
*/
