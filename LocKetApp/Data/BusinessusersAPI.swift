//
//  BusinessuserAPI.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/25.
//

import Foundation
import Alamofire

var businessuser: Businessuser?
func getLoginBusinessuser( id: String, handler: @escaping(Bool)->() ) {
    
    // 1 url request
    let strUrl = host + "/businessusers/" + id

    // 2 Alamofire
    AF.request(
        strUrl,
        method: .get
    ).responseDecodable(of: Businessuser.self) { response in
        debugPrint(response)
        switch response.result {
        case .success( _):
            guard let data = response.value else { fatalError() }
            businessuser = data
            handler(true)
        case .failure(let e):
            print(e.localizedDescription)
            handler(false)
        }
    }
}
