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
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var viewFrame: UIView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var imgVwRestroom: UIImageView!
    @IBOutlet var imgVwParking: UIImageView!
    @IBOutlet var lblStoreNumber: UILabel!
    @IBOutlet var lblProductList: UILabel!
    @IBOutlet var lblOpenDay: UILabel!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // style
        self.navigationController?.navigationBar.topItem?.title = ""  // 내비게이션바 back 문구 지우기

        
        // 데이터
        guard let user = user, let fiveMarket = fiveMarket else {return}
        
        // 마켓정보
        marketName.title = fiveMarket.mrktNm
        lblAddress.text = fiveMarket.rdnmadr
        imgVwRestroom.isHighlighted =  fiveMarket.pblicToiletYn == "Y" ? true : false
        imgVwParking.isHighlighted =  fiveMarket.prkplceYn == "Y" ? true : false
        lblStoreNumber.text = fiveMarket.storNumber
        let productList = fiveMarket.trtmntPrdlst.components(separatedBy: "+").joined(separator: ", ")
        lblProductList.text = productList
        let openDay = fiveMarket.mrktEstblCycle.components(separatedBy: "+").joined(separator: ", ")
        lblOpenDay.text = "장날: 매월 " + openDay
        
    
        //하트 색칠하기
        isFavorite = user.favorites.fav_fivemarkets.contains { element in
            if element.market_name == fiveMarket.mrktNm {
                return true
            }else { return false }
        }
        
        
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
        

        
        
    }
    
    // 전화걸기 기능
    @IBAction func touchUpForCalling(_ sender: UIButton) {
        let number:Int = 546506612
        
        // URLScheme 문자열을 통해 URL 인스턴스를 만들어 줍니다.
        if let url = NSURL(string: "tel://0" + "\(number)"),
           
            //canOpenURL(_:) 메소드를 통해서 URL 체계를 처리하는 데 앱을 사용할 수 있는지 여부를 확인
           UIApplication.shared.canOpenURL(url as URL) {
            
            //사용가능한 URLScheme이라면 open(_:options:completionHandler:) 메소드를 호출해서
            //만들어둔 URL 인스턴스를 열어줍니다.
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
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




