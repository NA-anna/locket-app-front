//
//  UserAPI.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/23.
//

import Foundation
import Alamofire

var user: User?
func getLoginUser( id: String, handler: @escaping(Bool)->() ) { 
    
    // 1 url request
    let strUrl = host + "/users/" + id

    // 2 Alamofire
    AF.request(
        strUrl,
        method: .get
    ).responseDecodable(of: User.self) { response in
        //debugPrint(response)
        switch response.result {
        case .success( _)://obj):
            guard let data = response.value else { fatalError() }
            user = data            
            handler(true)
        case .failure(let e):
            print(e.localizedDescription)
            handler(false)
        }
    }
}

func putUserData( collection route : String, id : String, body: [String : Any], handler: @escaping()->() ) {
    
    // 1 url request
    let strUrl = host + "/" + route + "/" + id

    // 2 Alamofire
    let params: Parameters = body
    print(params)
    AF.request(
        strUrl,
        method: .put,
        parameters: params,
        encoding: JSONEncoding.default // [인코딩 스타일]
    ).responseDecodable(of: User.self) { response in
        debugPrint(response)
        switch response.result {
        case .success(_)://obj): //통신성공
            print("PUT 응답 코드 :: ", response.response?.statusCode ?? 0)
            handler()
        case .failure(let e):   //통신실패
            print(e.localizedDescription)
        }
    }
}
/*
func updateUser( collection route : String, body: [String : Any] ) {
    
    // 1 url request
    let strUrl = host + "/" + route

    // 2 Alamofire
    let params: Parameters = body
    let headers: HTTPHeaders = ["Content-Type" : "application/json"]
    let alamo = AF.request(
        strUrl,
        method: .post,
        parameters: params,
        encoding: JSONEncoding.default, // [인코딩 스타일]
        headers: headers)
    alamo.responseDecodable(of: Markets.self) { response in

        //debugPrint(response)
        switch response.result {
        case .success(_)://obj): //통신성공
            print("응답 코드 :: ", response.response?.statusCode ?? 0)
        case .failure(let e):   //통신실패
            print(e.localizedDescription)
        }
    }
}
*/
