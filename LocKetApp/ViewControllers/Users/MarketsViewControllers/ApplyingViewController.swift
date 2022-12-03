//
//  ApplyingViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/26.
//

import UIKit


class ApplyingViewController: UIViewController {

    // 부모 화면에서 전달받은 데이터
    var market: Market?
    
    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "sellerprofile")
    
    @IBOutlet var lblHello: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var txtFldCategory: UITextField!
    @IBOutlet var txtFldSubCategory: UITextField!
    @IBOutlet var txtFldSNS: UITextField!
    @IBOutlet var txtVwDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        guard let user = user, let market = market else {return}
        let name = user.name
        
        // 오브젝트 설정
        lblHello.text = "\(name)님, \n'\(market.name)' 셀러 참가를 위해 \n아래 내용을 적어주세요"
        
        txtVwDescription.layer.borderWidth = 1.0
        txtVwDescription.layer.cornerRadius = 10
        txtVwDescription.layer.borderColor = UIColor.systemGray6.cgColor
        
        
        // UITextField 프로토콜
        txtFldSubCategory.delegate = self
        txtFldSNS.delegate = self
        
        
        // UIPickerView 프로토콜
        let picker = UIPickerView()
        picker.delegate = self
        self.txtFldCategory.inputView = picker // 텍스트 필드 입력 방식을 키보드 대신 피커 뷰로 설정
    }
    
    @IBAction func actPhotoLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    
    @IBAction func actApplying(_ sender: Any) {
        post()
    }

    
    // 빈 화면 터치 시 입력 닫기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func post() {
        
        // DB에 저장
        guard let user = user, let market = market, let market_id = market._id
              else {return}
        guard let category = txtFldCategory.text,
              let subCategory = txtFldSubCategory.text,
              let sns = txtFldSNS.text,
              let description = txtVwDescription.text else {return}
        let blobName = market.name + "_" + market_id + "_" + user.id
        let bodyData : [String: Any] = [
            "userId"     : user.id,
            "marketId"   : market_id,
            "category"   : category,
            "subCategory": subCategory,
            "sns"        : [sns],
            "description": description,
            "photo"      : [blobName],
            "state"      : "신청완료"
        ]
        postSeller( collection: "sellers", body: bodyData) { statusCode in
            if statusCode <= 204 {
                
                // alert 
                let alert = UIAlertController(title: "", message: "참여하기가 신청되었습니다!", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "확인", style: .default, handler: { _ in
                    //화면전환
                    self.tabBarController?.selectedIndex = 0
         
                })
                alert.addAction(actionOK)
                self.present(alert, animated: true)
            }else {
                // alert
                let alert = UIAlertController(title: "", message: "저장되지 못했습니다. 다시 확인 후 진행해주세요", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "확인", style: .default, handler: { _ in
                    //화면전환
                    self.tabBarController?.selectedIndex = 0
         
                })
                alert.addAction(actionOK)
                self.present(alert, animated: true)
                
            }
        }
  
        
        //Azure Storage에 사진 blob 저장
        guard let image = imageView.image else {return}
        blobstorage.uploadImage(image: image, blobName: blobName )
    
        
        
        
        
        
    }
}

// UIImagePicker -> Photo Library
extension ApplyingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return } //info[.originalImage] : Any? -> UIImage?
        imageView.image = image
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}







// UIPickerView
extension ApplyingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       // 컴포넌트가 가질 목록의 길이
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           guard let market = market, let sellersForm = market.sellersForm else { return 0 }
           return sellersForm.needCategory.count
       }
       
       // 컴포넌트의 목록 각 행에 출력될 내용
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           guard let market = market, let sellersForm = market.sellersForm else { return "" }
           return sellersForm.needCategory[row]
       }
       
       // 컴포넌트의 행을 선택했을 때 실행할 액션
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           
           guard let market = market, let sellersForm = market.sellersForm else { return }
           
           // 선택된 계정을 텍스트 필드에 입력
           let item = sellersForm.needCategory[row]
           self.txtFldCategory.text = item
           
           // 입력 뷰 닫기
           self.view.endEditing(true)
       }

}

// TextFiled [완료] 클릭 시 -> 키보드 닫기
extension ApplyingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //최초반응자 사임..
        txtFldSubCategory.resignFirstResponder()
        txtFldSNS.resignFirstResponder()
        
        return true
    }
}
