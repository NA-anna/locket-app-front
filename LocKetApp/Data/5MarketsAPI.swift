//
//  5MarketsAPI.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/21.
//

import Foundation
import Alamofire

//==================api Header 정보======================//
let serviceKey = "mAe+GWpPxmtRRex6gA7cL5l3Eno9CgDEaLfRPGK3L7JoGnLMku54NhrJr3wlr4wT6FH1UqUn1qXECQiO6xMS4g=="

//======================================================//
struct ResultDataOf5Market: Codable {
    let response: Response
    struct Response: Codable {
        let header: Header
        let body: Body
    }
}
struct Header: Codable {
    let resultCode: String
    let resultMsg: String
    let type: String
}
struct Body: Codable {
    let items : [Item]
    let totalCount: String
    let numOfRows: String
    let pageNo: String
}
struct Item: Codable, Hashable {
    let mrktNm: String
    let mrktType: String
    let rdnmadr: String
    let lnmadr: String
    let mrktEstblCycle: String
    let latitude: String
    let longitude: String
    let storNumber: String
    let trtmntPrdlst: String
    let useGcct: String
    let homepageUrl: String
    let pblicToiletYn: String
    let prkplceYn: String
    let estblYear: String
    let phoneNumber: String
    let referenceDate: String
    let insttCode: String
}

var fiveMarkets: [Item] = []
func get5Markets( numOfRows: Int, type: String, handler: @escaping()->() ) {
    
    // 1 url request
    let strUrl = "http://api.data.go.kr/openapi/tn_pubr_public_trdit_mrkt_api"

    // 2 Alamofire
    AF.request(
        strUrl,
        method: .get,
        parameters: ["serviceKey": serviceKey, "pageNo": 1, "numOfRows": numOfRows, "type": "json", "mrktType": type]
    ).responseDecodable(of: ResultDataOf5Market.self){ response in
        //debugPrint(response)
        switch response.result {
        case .success( _)://obj):
            guard let items = response.value?.response.body.items else { fatalError() }
            fiveMarkets = items
            handler()
        case .failure(let e):
            print(e.localizedDescription)
        }
    }
}


