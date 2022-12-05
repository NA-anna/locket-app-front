//
//  MarketCell.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/12/05.
//

import UIKit

class MarketCell: UITableViewCell {

    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "marketprofile")
    
    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var lbl: UILabel!
    @IBOutlet var btn: UIButton!
    
    //재사용 가능한 셀을 준비하는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // UITableView 오브젝트 세팅
    func setValues(market: Market, index: Int){
        
        // (1) 이미지
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
        // (2) 라벨
        lbl.text = market.name
        // (3) 버튼
        btn.isHidden = true
        if let sellersForm = market.sellersForm
        {
            if market.needSellers && sellersForm.deadline > Date().toString() { //모집중 마켓
                btn.isHidden = false
            }
        }
    
        
        // 태그걸기
        btn.tag = index
        
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
