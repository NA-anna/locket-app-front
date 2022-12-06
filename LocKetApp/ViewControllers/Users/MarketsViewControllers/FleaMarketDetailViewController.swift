//
//  FleaMarketDetailViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/25.
//

import UIKit
import CoreLocation

class FleaMarketDetailViewController: UIViewController, MTMapViewDelegate {
    
    var market: Market?
    var isGathering: Bool = false
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
    @IBOutlet var lblMarketName: UILabel!
    @IBOutlet var viewFrame: UIView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var btnApplying: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 화면에 뿌려본 것. 나중에 주석 필요
/*
        let jsonData: Data = try! JSONEncoder().encode(market) // data
        let jsonString: String = String.init(data: jsonData, encoding: .utf8) ?? "err"
        textView.text = jsonString
 */

        // style
        self.navigationController?.navigationBar.topItem?.title = ""  // 내비게이션바 back 문구 지우기
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        
        // 데이터
        guard let user = user, let market = market else {return}
        
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
        
        // 마켓정보
        guard let des = market.description else {return}
        lblMarketName.text = market.name
        textView.text = "날짜 : \(market.startdate) 부터 \(market.enddate)까지\n \n장소: \(market.place)\n\n\(des)"
        
        // 하트 색칠하기
        isFavorite = user.favorites.fav_fleamarkets.contains { element in
            if element.market_id == market._id {
                return true
            }else { return false }
        }
        
        // 신청하기 버튼 활성화
        btnApplying.isHidden = !isGathering
        
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
