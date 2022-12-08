//
//  MarketDetailViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/25.
//

import UIKit
import CoreLocation

class MarketDetailViewController: UIViewController, MTMapViewDelegate {
    
    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "marketprofile")
    
    var market: Market?
    var isFavorite: Bool = false{
        didSet(oldValue){
        }willSet(newValue){
            if newValue {
                btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else {
                btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
                //저장
            }
        }
    }
    @IBOutlet var marketName: UINavigationItem!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var viewFrame: UIView!
    @IBOutlet var lblAdress: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var btnApplying: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style
        self.navigationController?.navigationBar.topItem?.title = ""  // 내비게이션바 back 문구 지우기
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        
        // 데이터
        guard let user = user, let market = market else {return}
  
        // 사진 파일이 있으면 애저 스트로지에서 가져오기
        if market.photo.count > 0 {
            let blobName = market.photo[0]
            if blobName != "" {
                blobstorage.downloadImage(blobName: blobName, handler: { data in
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                })
            }
        }
        
        // 마켓정보
        guard let des = market.description else {return}
        marketName.title = market.name
        lblAdress.text = market.place
        lblDate.text = "\(market.startdate) 부터 \(market.enddate)까지\n \n\(des)"
        
        textView.text = "\(des)"
        
        // 하트 색칠하기
        isFavorite = user.favorites.fav_fleamarkets.contains { element in
            if element.market_id == market._id {
                return true
            }else { return false }
        }
        
        // 신청하기 버튼 활성화
        btnApplying.isHidden = !market.isGathering()
        
        
        

        // 맵뷰
        // 1 맵뷰 그리기 by Kakao
        var mapView: MTMapView!
        mapView = MTMapView(frame: self.viewFrame.bounds)
        mapView.delegate = self
        mapView.baseMapType = .standard
        self.viewFrame.addSubview(mapView)
        
        // 2 좌표 중심 설정 by Kakao
        let lat = Double(market.location.coordinates[0])
        let long = Double(market.location.coordinates[1])
        let defaultMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: lat, longitude: long))
        mapView.setMapCenter(defaultMapPoint, zoomLevel: 1, animated: true)
        

    }
    
    @IBAction func actFavorite(_ sender: UIButton) {
        isFavorite.toggle()
        
        guard var user = user, let market = market, let market_id = market._id else { return }
        let lat  = Double(market.location.coordinates[0])
        let long = Double(market.location.coordinates[1])
        let fav: FavFleaMarket = FavFleaMarket(market_id: market_id, location: Location(type: "Point", coordinates: [lat, long]))
        
        
        // T -> 저장
        if isFavorite {
            // 즐겨찾기에 추가
            user.favorites.fav_fleamarkets.append(fav)
            
            // 데이터 인코딩
            let jsonData: Data = try! JSONEncoder().encode(user)
            guard let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {return}
            
            // PUT
            putUserData( collection: "users", id: user.id, body: jsonDictionary ){ //bodyData ){
                 
                // GET (재조회)
                getLoginUser(id: user.id ){_ in }
            }
            
        // F -> 삭제
        }else {
            // 즐겨찾기에서 삭제
            if let index = user.favorites.fav_fleamarkets.firstIndex( where: { $0.market_id == market._id } ){
                user.favorites.fav_fleamarkets.remove(at: index)
            }
            
            // 데이터 인코딩
            let jsonData: Data = try! JSONEncoder().encode(user)
            guard let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {return}
            
            // PUT
            putUserData( collection: "users", id: user.id, body: jsonDictionary ){
                
                // GET (재조회)
                getLoginUser(id: user.id ){_ in }
            }
            
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? ApplyingViewController
        vc?.market = market
        
    }
}
