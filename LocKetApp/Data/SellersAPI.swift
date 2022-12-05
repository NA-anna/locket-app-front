//
//  SellerAPI.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/27.
//

import Foundation
import Alamofire

var sellers: [Seller] = []
// 내가 신청한 셀러 목록
func getSellersByUser( userId: String, handler: @escaping()->() ) {
    
    // 1 url request
    let strUrl = host + "/sellers-byUser/" + userId

    // 2 Alamofire
    AF.request(
        strUrl,
        method: .get
    ).responseDecodable(of: Sellers.self) { response in
        debugPrint(response)
        switch response.result {
        case .success(_):
            guard let data = response.value else { fatalError() }
            let documents = data.documents
            sellers = documents
            handler()
        case .failure(let e):
            print(e.localizedDescription)
            handler()
        }
    }
}
// 신청된 셀러 목록
func getSellersByMarket( marketId: String, handler: @escaping()->() ) {
    // 1 url request
    let strUrl = host + "/sellers-byMarket/" + marketId

    // 2 Alamofire
    AF.request(
        strUrl,
        method: .get
    ).responseDecodable(of: Sellers.self) { response in
        debugPrint(response)
        switch response.result {
        case .success(_):
            guard let data = response.value else { fatalError() }
            let documents = data.documents
            sellers = documents
            handler()
        case .failure(let e):
            print(e.localizedDescription)
            handler()
        }
    }
    
}

// 셀러 등록 (신청)
func postSeller( collection route : String, body: [String : Any], handler: @escaping(Int)->() ) {
    
    // 1 url request
    let strUrl = host + "/" + route

    // 2 Alamofire
    let params: Parameters = body
    AF.request(
        strUrl,
        method: .post,
        parameters: params,
        encoding: JSONEncoding.default // [인코딩 스타일]
    ).responseDecodable(of: Seller.self) { response in

        debugPrint(response)
        if let res = response.response{
            handler(res.statusCode)
        }

    }
}

// 셀러 변경
func putSellerData( id : String, body: [String : Any], handler: @escaping(Int)->() ) {
    
    // 1 url request
    let strUrl = host + "/sellers/" + id

    // 2 Alamofire
    let params: Parameters = body
    AF.request(
        strUrl,
        method: .put,
        parameters: params,
        encoding: JSONEncoding.default // [인코딩 스타일]
    ).responseDecodable(of: User.self) { response in
        debugPrint(response)
        if let res = response.response{
            handler(res.statusCode)
        }
    }
}
