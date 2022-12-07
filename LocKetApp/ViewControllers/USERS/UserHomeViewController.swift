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
    
    var recruitingMarkets = markets
    
    @IBOutlet var lblHello: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {return}
        let name = user.name
        lblHello.text = "\(name)님, \n안녕하세요."
        
        // UICollectionView 데이터
        recruitingMarkets = recruitingMarkets.filter { market in
            guard let sellersForm = market.sellersForm else { return false }
            let today = Date().toString()
            return market.needSellers && sellersForm.deadline > today
        }
        
        // UICollectionView 프로토콜
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
    }
    
    // 빈 화면 터치 시 키보드 내려가기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueID = segue.identifier
        if segueID == "gatheringMarket"{
            let childVC = segue.destination as? FleaMarketDetailViewController
            if let cell = sender as? UICollectionViewCell,
               let indexPath = self.collectionView?.indexPath(for: cell){
                childVC?.market = recruitingMarkets[indexPath.row]
            }
        }
    }
}






// UICollectionView 프로토콜

extension UserHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recruitingMarkets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marketcell", for: indexPath)
        
        let market = recruitingMarkets[indexPath.row]
        
        cell.layer.cornerRadius = 10
        
        // 사진 파일이 있으면 애저 스트로지에서 가져오기
        let imageView = cell.viewWithTag(1) as? UIImageView
        if market.photo.count > 0 {
            let blobName = market.photo[0]
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

        let lblName = cell.viewWithTag(2) as? UILabel
        lblName?.text = market.name

        let lblName2 = cell.viewWithTag(3) as? UILabel
        lblName2?.text = market.place
        
        let lblName3 = cell.viewWithTag(4) as? UILabel
        lblName3?.text = market.description
        
        return cell
        
    }
    //간격?
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height //* 2/3
        return CGSize(width: height * 1, height: height)
    }
}

