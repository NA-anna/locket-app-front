//
//  AddViewController.swift
//  miniProject01
//
//  Created by 나유진 on 2022/10/26.
//

import UIKit

class AddViewController: UIViewController {
    
    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "marketprofile")

    var arrCheck: [Bool] = [Bool](repeating: false, count: gSellerCategories.count){
        didSet{
            var arr: [String] = []
            for i in 0..<gSellerCategories.count {
                if arrCheck[i] {
                    arr.append(gSellerCategories[i])
                }
            }
            txtFldSellerCategories.text = arr.joined(separator: ", ")
        }
    }
    // child view 에서 선택된 데이터
    var place: Document?{
        didSet(oldValue){
        }willSet(newValue){
            txtFldPlace.text = newValue?.place_name
            latitude = newValue?.y
            longitude = newValue?.x
            enableAddBtn()
        }
    }
    var latitude: String?
    var longitude: String?
    let textViewPlaceHolder = "자세한 설명을 적어주세요." //스토리보드의 텍스트뷰의 dedfault text와 일치 시켜야 동작함
    
    @IBOutlet var btnDone: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var txtFldName: UITextField!
    @IBOutlet weak var txtFldCategory: UITextField!
    @IBOutlet var datePickerStartDate: UIDatePicker!
    @IBOutlet var datePickerEndDate: UIDatePicker!
    @IBOutlet weak var txtFldPlace: UITextField!
    @IBOutlet var txtVwDescription: UITextView!
    @IBOutlet var viewSellers: UIView!
    @IBOutlet var swSeller: UISwitch!
    @IBOutlet var txtFldSellerCount: UITextField!
    @IBOutlet var datePickerDeadline: UIDatePicker!
    @IBOutlet var txtFldSellerCategories: UITextField!
    @IBOutlet var txtVwSellerDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style
        self.navigationController?.navigationBar.topItem?.title = ""  // 내비게이션바 back 문구 지우기
        
        txtVwDescription.layer.borderWidth = 1.0
        txtVwDescription.layer.cornerRadius = 10
        txtVwDescription.layer.borderColor = UIColor.systemGray6.cgColor
        
        txtVwSellerDescription.layer.borderWidth = 1.0
        txtVwSellerDescription.layer.cornerRadius = 10
        txtVwSellerDescription.layer.borderColor = UIColor.systemGray6.cgColor
        
        // 오브젝트 세팅
        viewSellers.isHidden = true
        
        // UITextField 프로토콜
        txtFldName.delegate = self
        
        // UITextView 프로토콜
        txtVwDescription.delegate = self
        txtVwSellerDescription.delegate = self
        
        // UIPickerView 프로토콜
        let picker = UIPickerView()
        picker.delegate = self
        self.txtFldCategory.inputView = picker // 텍스트 필드 입력 방식을 키보드 대신 피커 뷰로 설정
   
    }
    // 빈 화면 터치 시 입력 닫기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func actPhotoLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    @IBAction func actTitleDidEnd(_ sender: Any) {
        enableAddBtn()
    }
    @IBAction func actCategoryValueChanged(_ sender: Any) {
        enableAddBtn()
    }
    @IBAction func swNeedSellers(_ sender: UISwitch) {
       
        if  sender.isOn{
            viewSellers.isHidden = false
        }else {
            viewSellers.isHidden = true
            enableAddBtn()
        }
          
    }
    @IBAction func actSelletCountDidEnd(_ sender: Any) {
        enableAddBtn()
    }
    @IBAction func actSellerCategoryValueChanged(_ sender: Any) {
        enableAddBtn()
    }
    @IBAction func actDone(_ sender: Any) {
        post()
    }
    
    
    
    // 입력 확인(타이틀, 카테고리, 장소) 후 버튼 활성화 함수
    func enableAddBtn(){
        if txtFldName.text != "" && txtFldCategory.text != "" && txtFldPlace.text != "" && txtVwDescription.text != textViewPlaceHolder
        {
            if swSeller.isOn && txtFldSellerCount.text != "" && txtFldSellerCategories.text != "" && txtVwSellerDescription.text != textViewPlaceHolder {
                btnDone.isEnabled = true
                return
            }else if !swSeller.isOn {
                btnDone.isEnabled = true
                return
            }

        }
    }

    
    func post(){
        // DB에 저장
        guard let businessuser = businessuser,
              let title = txtFldName.text,
              let category = txtFldCategory.text,
              let place = txtFldPlace.text,
              let latitude = latitude,
              let longitude = longitude,
              let description = txtVwDescription.text,
              let sellersCount = txtFldSellerCount.text,
              let needCategories = txtFldSellerCategories.text?.components(separatedBy: ", "),
              let sellerDescriptiob = txtVwSellerDescription.text
        else { return }
        var startDate = datePickerStartDate.date.toString()
        var idx = startDate.index(startDate.startIndex, offsetBy: 9)
            startDate = String(startDate[...idx])
        var endDate = datePickerEndDate.date.toString()
            idx = endDate.index(endDate.startIndex, offsetBy: 9)
            endDate = String(endDate[...idx])
        var deadline = datePickerDeadline.date.toString()
            idx = deadline.index(deadline.startIndex, offsetBy: 9)
            deadline = String(deadline[...idx])
    
        let blobName = businessuser.id + "_" + title + "_" + UUID().uuidString //블롭네임은 iseoulu_한강달빛야시장_랜덤넘버
                    
        let bodyData : [String: Any] = swSeller.isOn ?
        [
            "businessusersId" : businessuser.id,
            "name"            : title,
            "category"        : category,
            "place"           : place,
            "location"        : [ "type": "Point",
                                  "coordinates": [latitude, longitude] ],
            "startdate"       : startDate,
            "enddate"         : endDate,
            "description"     : description,
            "photo"           : [blobName],
            "isPromotional"   : false,
            "needSellers"     : true,
            "sellersForm"     : [ "sellersCount" : sellersCount,
                                  "deadline"     : deadline,
                                  "needCategory" : needCategories,
                                  "description"  : sellerDescriptiob
                                ]
        ] : [
            "businessusersId" : businessuser.id,
            "name"            : title,
            "category"        : category,
            "place"           : place,
            "location"        : [ "type": "Point",
                                  "coordinates": [latitude, longitude] ],
            "startdate"       : startDate,
            "enddate"         : endDate,
            "description"     : description,
            "photo"           : [blobName],
            "isPromotional"   : false,
            "needSellers"     : false
        ]
    
        // POST
        postMarketData(collection: "markets", body: bodyData, handler: { statusCode in
            if statusCode <= 204 {
                // alert
                let alert = UIAlertController(title: "", message: "마켓이 등록되었습니다!", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "확인", style: .default, handler: { _ in
                    
                    // GET (재조회)
                    getMarketsOfBusinessuser(businessuserId: businessuser.id) {
                        
                        //화면전환
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                })
                alert.addAction(actionOK)
                self.present(alert, animated: true)
            }else {
                // alert
                let alert = UIAlertController(title: "", message: "등록되지 못했습니다. 다시 확인 후 진행해주세요", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "확인", style: .default, handler: { _ in
                })
                alert.addAction(actionOK)
                self.present(alert, animated: true)
                
            }
        })
              
        //Azure Storage에 사진 blob 저장
        guard let image = imageView.image else {return}
        blobstorage.uploadImage(image: image, blobName: blobName )
        
    }
    


    
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueID = segue.identifier
        if segueID == "category"{
            let childVC = segue.destination as? AddViewController_category
            childVC?.parentVC = self
        
        }else if segueID == "place"{
            let childVC = segue.destination as? AddViewController_place
            childVC?.parentVC = self
        }
    }
    

    

}

//===========================================================================================
// Extension 확장 - Protocol
//===========================================================================================

// UIImagePicker -> Photo Library
extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return } //info[.originalImage] : Any? -> UIImage?
        imageView.image = image
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

// UIPickerView -> 카테고리
extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       // 컴포넌트가 가질 목록의 길이
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
  
           return gCategories.count
       }
       
       // 컴포넌트의 목록 각 행에 출력될 내용
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           
           return gCategories[row]
       }
       
       // 컴포넌트의 행을 선택했을 때 실행할 액션
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
           // 선택된 계정을 텍스트 필드에 입력
           let item = gCategories[row]
           self.txtFldCategory.text = item
           
           // 입력 뷰 닫기
           self.view.endEditing(true)
       }

}



// UITextFiled : [완료] 클릭 시 -> 키보드 닫기
extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //최초반응자 사임..
        txtFldName.resignFirstResponder()
        return true
    }
}

// UITextView : placeholder 기능
extension AddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}
