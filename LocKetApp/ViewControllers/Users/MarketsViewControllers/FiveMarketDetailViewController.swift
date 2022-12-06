//
//  FiveMarketDetailViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/22.
//  

import UIKit
import CoreLocation
import MapKit

class FiveMarketDetailViewController: UIViewController, MTMapViewDelegate {

    var fiveMarket: Item?
    var isFavorite: Bool = false{
        didSet(oldValue){
        }willSet(newValue){
            if newValue {
                btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else {
                btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    @IBOutlet var marketName: UINavigationItem!
    @IBOutlet var viewFrame: UIView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var btnLike: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 화면에 뿌려본 것. 나중에 주석 필요
/*
        let jsonData: Data = try! JSONEncoder().encode(fiveMarket) // data
        let jsonString:String = String.init(data: jsonData, encoding: .utf8) ?? "err"
        textView.text = jsonString
*/
        // UITextView style
        viewFrame.layer.cornerRadius = 20
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        
        // 데이터
        guard let user = user, let fiveMarket = fiveMarket else {return}
        
        // 맵뷰
        // 1 맵뷰 그리기 by Kakao
        var mapView: MTMapView!
        mapView = MTMapView(frame: self.viewFrame.bounds) 
        mapView.delegate = self
        mapView.baseMapType = .standard
        self.viewFrame.addSubview(mapView)
        
        // 2 좌표 중심 설정 by Kakao
        guard let lat = Double(fiveMarket.latitude),
              let long = Double(fiveMarket.longitude) else {return}
        let defaultMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: lat, longitude: long))
        mapView.setMapCenter(defaultMapPoint, zoomLevel: 1, animated: true)
        
        // 마켓정보
        let productList = fiveMarket.trtmntPrdlst.components(separatedBy: "+").joined(separator: ", ")
        marketName.title = fiveMarket.mrktNm
        textView.text = "점포 수: \(fiveMarket.storNumber)\n상품: \(productList)\n\n주소\n(도로명):\(fiveMarket.rdnmadr) \n(지번):\(fiveMarket.lnmadr)\n\n공용화장실 유뮤: \(fiveMarket.pblicToiletYn)\n주차장: \(fiveMarket.prkplceYn)"
        
        //하트 색칠하기
        isFavorite = user.favorites.fav_fivemarkets.contains { element in
            if element.market_name == fiveMarket.mrktNm {
                return true
            }else { return false }
        }
        
        
    }
    
    // [즐겨찾기] 터치! -> PUT
    @IBAction func actFavorite(_ sender: UIButton) {
        isFavorite.toggle()
        
        guard var user = user, let fiveMarket = fiveMarket else { return }
        let lat  = Double(fiveMarket.latitude) ?? 0
        let long = Double(fiveMarket.longitude) ?? 0
        let fav: FavFivemarket = FavFivemarket(market_name: fiveMarket.mrktNm, location: Location(type: "Point", coordinates: [lat, long]))
        
        
        // T -> 저장
        if isFavorite {
            // 즐겨찾기에 추가
            user.favorites.fav_fivemarkets.append(fav)
            
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
            if let index = user.favorites.fav_fivemarkets.firstIndex( where: { $0.market_name == fiveMarket.mrktNm } ){
                user.favorites.fav_fivemarkets.remove(at: index)
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
}




