//
//  MypageViewController.swift
//  LocKetApp
//
//  Created by yeonji on 2022/11/26.
//

import UIKit

class MypageViewController: UIViewController {

    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "userprofile")
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var userProfile: RoundUIImageView!
    @IBOutlet var nickName: UILabel!
    @IBOutlet var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        
        guard let user = user else {return}
        
        let name = user.name
        nickName.text = "\(name)"
        
        let email = user.email
        userEmail.text = "\(email)"
        
        // 사진 파일이 있으면 애저 스트로지에서 가져오기
        let blobName = user.id + ".png"
        if blobName != "" {
            blobstorage.downloadImage(blobName: blobName, handler: { data in
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.userProfile?.image = image
                }
            })
        }
        
    }
    


}
extension MypageViewController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let symbol = cell.viewWithTag(1) as? UIImageView
        let label = cell.viewWithTag(2) as? UILabel
        
        switch indexPath.row{
        case 0:
            symbol?.image = UIImage(systemName: "bell")
            symbol?.tintColor = .label
            label?.text = "나의 신청 마켓"
            
//        case 1:
//            symbol?.image = UIImage(systemName: "heart")
//            symbol?.tintColor = .label
//            label?.text = "관심목록"
            
        case 1:
            symbol?.image = UIImage(systemName: "questionmark.circle")
            symbol?.tintColor = .label
            label?.text = "고객센터"
            
        case 2:
            symbol?.image = UIImage(systemName: "ipad.and.arrow.forward")
            symbol?.tintColor = .label
            label?.text = "로그아웃"
            
        default:
            print("디폴트~")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            let storyBoard = UIStoryboard(name: "MypageSt", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AppliedListView")
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = CustomModalViewController()
            vc.modalPresentationStyle = .overCurrentContext
            // keep false
            // modal animation will be handled in VC itself
            self.present(vc, animated: false)
        case 2:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "login")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        default:
            print("디폴트~")
        }
    }
    
}
