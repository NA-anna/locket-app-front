//
//  LaunchViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/28.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 데이터 가져오기 작업
        
        // (1) 5일장 데이터 가져와서 합치기 fiveMarkets -> fiveMarkets (for Map)
        var combinedFiveMarkets: [Item] = []
        get5Markets( numOfRows: 100, type: "5일장") {
            combinedFiveMarkets = fiveMarkets
            get5Markets( numOfRows: 100, type: "상설장+5일장") {
                combinedFiveMarkets.append(contentsOf: fiveMarkets)
                fiveMarkets = combinedFiveMarkets
            }
        }
        // (2) 플리마켓 데이터 가져오기
        getMarkets {}
        //-----------------------------------------------
        
    
    
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "login")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
        
    }
    

}
