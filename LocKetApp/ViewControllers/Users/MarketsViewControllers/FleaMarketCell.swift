//
//  FleaMarketCell.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/12/06.
//

import UIKit

class FleaMarketCell: UITableViewCell {

    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "marketprofile")
    
    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblPlace: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblCategory: UILabel!
    
    // UITableView 오브젝트 세팅
    func setValues(market: Market, index: Int){
        
        // 스타일
        imgVw.layer.cornerRadius = 10
        
        // TABLE VIEW 에 값 지정
    
        // 사진 파일이 있으면 애저 스트로지에서 가져오기
        if market.photo.count > 0 {
            let blobName = market.photo[0]
            if blobName != "" {
                blobstorage.downloadImage(blobName: blobName, handler: { data in
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imgVw.image = image
                    }
                })
            }
        // 사진 파일이 없으면 디폴트 이미지
        }else {
            imgVw.image = UIImage(named: "rocket_up")
        }
    
        lblTitle.text = market.name
    
        lblCategory.text = market.category
    
        lblPlace.text = "장소: \(market.place)"
    
        lblDate.text = "\(market.startdate) ~ \(market.enddate)"
    
        lblDescription.text = market.description

        
        
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
