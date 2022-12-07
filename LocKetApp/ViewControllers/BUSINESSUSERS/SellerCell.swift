//
//  SellerCell.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/12/05.
//

import UIKit

class SellerCell: UITableViewCell {

    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "sellerprofile")
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblSNS: UILabel!
    @IBOutlet var txtViewDescription: UITextView!
    @IBOutlet var btn: UIButton!
    
    //재사용 가능한 셀을 준비하는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // UITableView 오브젝트 세팅
    func setValues(seller: Seller, index: Int){
        
        // (1) 라벨
        if let index = markets.firstIndex(where: { $0._id == seller.marketId }){
            let marketName = markets[index].name
            lblName.text = marketName
        }
        lblCategory.text = seller.category + " > " + seller.subCategory
        lblSNS.text = seller.sns.joined(separator: ", ")
        txtViewDescription.text = seller.description
        btn.setTitle(seller.state, for: .normal)
        
        // (2) 이미지
        // 사진 파일이 있으면 애저 스트로지에서 가져오기
        if seller.photo.count > 0 {
            let blobName = seller.photo[0]
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
