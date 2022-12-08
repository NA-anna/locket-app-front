//
//  FiveMarketCell.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/12/06.
//

import UIKit

class FiveMarketCell: UITableViewCell {

    
    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPlace: UILabel!
    //@IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    // UITableView 오브젝트 세팅
    func setValues(market: Item, index: Int){
        
        
        // TABLE VIEW 에 데이터 뿌리기
        lblTitle.text = market.mrktNm
                
        if let idx = market.rdnmadr.firstIndex(of: " ") {
            let place = market.rdnmadr[...idx]
            lblPlace.text = "\(place)"
        }else {
            lblPlace.text = "주소: \(market.rdnmadr)"
        }
        

        let openDay = market.mrktEstblCycle.components(separatedBy: "+").joined(separator: ", ")
        lblDate.text = openDay

//        let productList = "판매품목: " + market.trtmntPrdlst.components(separatedBy: "+").joined(separator: ", ")
//        lblDescription.text = productList
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
