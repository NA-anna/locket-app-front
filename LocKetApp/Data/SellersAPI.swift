//
//  SellerAPI.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/27.
//

import Foundation
import Alamofire

var sellers: [Seller] = []
func getSeller( userId: String, handler: @escaping()->() ) {
    
    // 1 url request
    let strUrl = host + "/sellers/" + userId

    // 2 Alamofire
    AF.request(
        strUrl,
        method: .get
    ).responseDecodable(of: Sellers.self) { response in
        debugPrint(response)
        switch response.result {
        case .success( _)://obj):
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

func postSeller( collection route : String, body: [String : Any], handler: @escaping(Bool)->() ) {
    
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
        switch response.result {
        case .success(_)://obj): //통신성공
            handler(true)
        case .failure(let e):   //통신실패
            print(e.localizedDescription)
            handler(false)
        }
    }
}
