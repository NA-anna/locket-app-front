//
//  DataModel.swift
//  LocketApp
//
//  Created by 나유진 on 2022/11/20.
//

import Foundation



/*------------------------------*/
// users
/*------------------------------*/
struct User: Codable {
    let _id      : String
    let id       : String
    let loginPw  : String
    let name     : String
    let profile  : String
    let tel      : String
    let email    : String
    var favorites: Favorites
}
struct Favorites: Codable {
    var fav_fleamarkets: [FavFleaMarket]
    var fav_fivemarkets: [FavFivemarket]
}
struct FavFleaMarket : Codable {
    var market_id: String
    var location : Location
}
struct FavFivemarket : Codable {
    var market_name: String
    var location   : Location
}

/*------------------------------*/
// businessusers
/*------------------------------*/
struct Businessuser: Codable {
    let _id       : String
    let id        : String
    let loginPw   : String
    let name      : String
    let businessNo: String
    let tel       : String
}

/*------------------------------*/
// markets
/*------------------------------*/
struct Markets: Codable {
    let documents : [Market]
}
struct Market: Codable, Equatable {
    static func == (lhs: Market, rhs: Market) -> Bool {
        return true
    }
    
    let _id            : String?
    let businessusersId: String
    let name           : String       // 마켓 이름
    let category       : String       // [ct001: 플리마켓, ct002: 야시장]
    let place          : String       // 마켓 열리는 장소
    let location       : Location
    let startdate      : String
    let enddate        : String
   // let site           : String
    let description    : String?
    let photo          : [String]
    let isPromotional  : Bool
    let needSellers    : Bool
    let sellersForm    : SellersForm?
    
    func isGathering() -> Bool {
        if let sellersForm = sellersForm {
            return (needSellers && sellersForm.deadline > Date().toString())
        } else {
            return false
        }
    }
   // var isGathering: Bool = (needSellers && sellersForm.deadline > Date().toString())

}
struct Location: Codable {
    let type       : String  //"Point"
    let coordinates: [Double]
}
struct SellersForm : Codable {
  let sellersCount   : Int
  let deadline       : String
  let needCategory   : [String]     //["음식", "의류", "소품", "수제"]
  //let charge         : String
  let description    : String
}
/*------------------------------*/
// sellers
/*------------------------------*/
struct Sellers: Codable {
    let documents : [Seller]
}
struct Seller : Codable {
    let _id        : String?
    let userId     : String
    let marketId   : String
    let category   : String
    let subCategory: String
    let sns        : [String]
    let description: String
    let photo      : [String]
    var state      : String
}
