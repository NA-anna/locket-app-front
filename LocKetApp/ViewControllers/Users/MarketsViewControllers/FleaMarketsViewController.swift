//
//  FleaMarketsViewController.swift
//  LocketApp
//
//  Created by 나유진 on 2022/11/20.
//
  
import UIKit

class FleaMarketsViewController: UITableViewController {

    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "marketprofile")
    
    var recruitingMarkets = markets
    
    @IBOutlet var segCon: UISegmentedControl!  // 장날보기|모집중 세그먼트
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // 세그먼트 변경 액션
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
       //모집중
        if segCon.selectedSegmentIndex == 1 {
            recruitingMarkets = recruitingMarkets.filter { market in
                guard let sellersForm = market.sellersForm else { return false }
                let today = Date().toString()
                return market.needSellers && sellersForm.deadline > today
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segCon.selectedSegmentIndex == 1 {
            return recruitingMarkets.count
        }
        return markets.count
//        if segCon.selectedSegmentIndex == 0 {
//            return markets.count
//        }else {
//            return filtered.count
//        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marketscell", for: indexPath)

        // 악세사리
        //cell.accessoryType = .disclosureIndicator //UIImageView(image: UIImage(systemName: "heart"))
        
        
        var market = markets[indexPath.row]
        if segCon.selectedSegmentIndex == 1 {
            market = recruitingMarkets[indexPath.row]
        }
        
        // TABLE VIEW 에 값 지정
        // 사진 파일이 있으면 애저 스트로지에서 가져오기
        if market.photo.count > 0 {
            let blobName = market.photo[0]
            if blobName != "" {
                blobstorage.downloadImage(blobName: blobName, handler: { data in
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        let imageView = cell.viewWithTag(10) as? UIImageView
                        imageView?.image = image
                    }
                })
            }
        // 사진 파일이 없으면 디폴트 이미지
        }else {
            let imageView = cell.viewWithTag(10) as? UIImageView
            imageView?.image = UIImage(named: "rocket_up")
        }
        let lblTitle = cell.viewWithTag(1) as? UILabel
        lblTitle?.text = market.name
        let lblCategory = cell.viewWithTag(2) as? UILabel
        lblCategory?.text = market.category
        let lblPlace = cell.viewWithTag(3) as? UILabel
        lblPlace?.text = "장소: \(market.place)"
        let lblDate = cell.viewWithTag(4) as? UILabel
        lblDate?.text = "\(market.startdate) ~ \(market.enddate)"
        let lblDescription = cell.viewWithTag(5) as? UILabel
        lblDescription?.text = market.description


        return cell
    }
    

 





    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? FleaMarketDetailViewController
        if let index = tableView.indexPathForSelectedRow?.row {
            vc?.market = markets[index]
            vc?.isGathering = (segCon.selectedSegmentIndex == 1) //모집중이면 True
        }
    }


}
