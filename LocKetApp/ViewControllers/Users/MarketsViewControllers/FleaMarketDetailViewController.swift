//
//  FleaMarketDetailViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/25.
//

import UIKit

class FleaMarketDetailViewController: UIViewController {
    
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
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var btnApplying: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 화면에 뿌려본 것. 나중에 주석 필요
        let jsonData: Data = try! JSONEncoder().encode(market) // data
        let jsonString: String = String.init(data: jsonData, encoding: .utf8) ?? "err"
        textView.text = jsonString

        // 신청하기 버튼 활성화
        btnApplying.isHidden = !isGathering
        
        // 하트 색칠하기
        if let user = user, let market = market {
            isFavorite = user.favorites.fav_fleamarkets.contains { element in
                if element.market_id == market._id {
                    return true
                }else { return false }
            }
        }
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
        let vc = segue.destination as? SellerApplyingViewController
        vc?.market = market
        
    }
}
