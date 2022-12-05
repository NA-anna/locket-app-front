//
//  RestAPI.swift
//  LocketApp
//
//  Created by 나유진 on 2022/11/19.
//

import Foundation
import Alamofire

// 마켓 목록 조회
var markets: [Market] = []
func getMarkets( handler: @escaping()->() ) {
    
    // 1 url request
    let strUrl = host + "/markets"

    // 2 Alamofire
    AF.request(
        strUrl,
        method: .get
    ).responseDecodable(of: Markets.self) { response in
        debugPrint(response)
        switch response.result {
        case .success( _)://obj):
            guard let data = response.value else { fatalError() }
            let documents = data.documents
            markets = documents
            handler()
        case .failure(let e):
            print(e.localizedDescription)
        }
    }
}

// 해당 사업자가 등록한 마켓 목록 조회
func getMarketsOfBusinessuser( businessuserId: String, handler: @escaping()->() ) {
    
    // 1 url request
    let strUrl = host + "/markets/" + businessuserId

    // 2 Alamofire
    AF.request(
        strUrl,
        method: .get
    ).responseDecodable(of: [Market].self) { response in
        debugPrint(response)
        switch response.result {
        case .success( _)://obj):
            guard let data = response.value else { fatalError() }
            let documents = data
            markets = documents
            handler()
        case .failure(let e):
            print(e.localizedDescription)
        }
    }
}
// 마켓 등록
func postMarketData( collection route : String, body: [String : Any], handler: @escaping(Int)->() ) {
    
    // 1 url request
    let strUrl = host + "/" + route

    // 2 Alamofire
    let params: Parameters = body
    AF.request(
        strUrl,
        method: .post,
        parameters: params,
        encoding: JSONEncoding.default // [인코딩 스타일]
    ).responseDecodable(of: Market.self) { response in

        debugPrint(response)
        if let res = response.response{
            handler(res.statusCode)
        }
//        switch response.result {
//        case .success(_)://obj): //통신성공
//            handler(true)
//        case .failure(let e):   //통신실패
//            print(e.localizedDescription)
//            handler(false)
//        }
    }
}

