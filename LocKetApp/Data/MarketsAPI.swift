//
//  RestAPI.swift
//  LocketApp
//
//  Created by 나유진 on 2022/11/19.
//

import Foundation
import Alamofire

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

func postMarketData( collection route : String, body: [String : Any], handler: @escaping(Bool)->() ) {
    
    // 1 url request
    let strUrl = host + "/" + route

    // 2 Alamofire
    let params: Parameters = body
    AF.request(
        strUrl,
        method: .post,
        parameters: params,
        encoding: JSONEncoding.default // [인코딩 스타일]
    ).responseDecodable(of: Markets.self) { response in

        //debugPrint(response)
        switch response.result {
        case .success(_)://obj): //통신성공
            handler(true)
        case .failure(let e):   //통신실패
            print(e.localizedDescription)
            handler(false)
        }
    }
}

