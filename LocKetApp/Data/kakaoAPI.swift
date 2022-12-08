//
//  kakaoAPI.swift
//  miniProject_map
//
//  Created by 나유진 on 2022/10/27.
//

import Foundation

//==================api Header 정보======================//
let apiKey = "KakaoAK 1c3e41abd5481798615063b4754f1792"
//======================================================//

//===========================================================================================
// kakao search place api 에서 GET 하는 데이터의 구조체 선언
//===========================================================================================
struct Document: Codable {
    let address_name: String?
    let category_group_code: String?
    let category_group_name: String?
    let category_name: String?
    let distance: String?
    let id: String?
    let phone: String?
    let place_name: String?
    let place_url: String?
    let road_address_name: String?
    let x: String?
    let y: String?
}
struct SameName: Codable {
    let keyword: String?
    let region: [String]?
    let selected_region: String?
}
struct Meta: Codable{
    let is_end: Bool?
    let pageable_count: Int?
    let same_name: SameName?
    let total_count: Int?
}
struct ResultData: Codable {
    let documents: [Document]?
    let meta: Meta?
}


//===========================================================================================
// kakao search place api 에서 GET
//===========================================================================================
var placePublicData: ResultData?

func callApiForPlace(with query: String?){  //외부 매개변수로 with를 쓰는게 관례적
        
    guard let query = query else { return }
    let page = 1
    
    // 1 url
    let str = "https://dapi.kakao.com/v2/local/search/keyword.JSON?query=\(query)&page=\(page)"
    
    // url 엔코딩
    guard let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: strURL) else { return }
        
    // 2 URLRequest
    var request = URLRequest(url: url)
    request.addValue(apiKey, forHTTPHeaderField: "Authorization") // Header 추가
    let session = URLSession.shared
    
    //3 작업 단위 만들기
    // 시간이 오래걸리는 작업은 자동으로 글로벌큐로 보내버림
    let task = session.dataTask(with: request) { data, response, error -> Void in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let data = data else { return }
        
        // 4 Parsing
        do{
            placePublicData = try JSONDecoder().decode(ResultData.self, from: data)
        }catch {
            print("==kakao search place api 파싱 실패==")
        }
    }
    task.resume()//만든 작업단위를 실행해라
    
    
}





