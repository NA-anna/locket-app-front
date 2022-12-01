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
    
    /*
    var categories: String?{
        didSet(oldValue){
        }willSet(newValue){
            txtFldSellerCategories.text = newValue
            enableAddBtn()
        }
    }*/
    var arrCheck: [Bool] = [Bool](repeating: false, count: gSellerCategories.count){
        didSet{
            var arr: [String] = []
            for i in 0..<gSellerCategories.count {
                if arrCheck[i] {
                    arr.append(gSellerCategories[i])
                }
            }
            txtFldSellerCategories.text = arr.joined(separator: ", ")
            print(arr)
        }
    }
    var place: Document?{
        didSet(oldValue){
        }willSet(newValue){
            txtFldPlace.text = newValue?.place_name
            latitude = newValue?.x
            longitude = newValue?.y
            enableAddBtn()
        }
    }
    var latitude: String?
    var longitude: String?
    
    @IBOutlet var btnDone: UIBarButtonItem!
    @IBOutlet var lblHello: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldCategory: UITextField!
    @IBOutlet var datePickerStartDate: UIDatePicker!
    @IBOutlet var datePickerEndDate: UIDatePicker!
    @IBOutlet weak var txtFldPlace: UITextField!
    @IBOutlet weak var txtFldDescription: UITextView!
    @IBOutlet var viewSellers: UIView!
    @IBOutlet var txtFldSellerCount: UITextField!
    @IBOutlet var datePickerDeadline: UIDatePicker!
    @IBOutlet var txtFldSellerCategories: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let businessuser = businessuser else {return}
        
        // 오브젝트 설정
        let name = businessuser.name
        lblHello.text = "\(name)님, \n'마켓 등록를 위해 \n아래 내용을 적어주세요"
        
        // UITextField 프로토콜
        txtFldName.delegate = self
        
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
    @IBAction func swNeedSellers(_ sender: UISwitch) {
       
        
        if  sender.isOn{
            viewSellers.isHidden = false
        }else {
            viewSellers.isHidden = true
        }
          
    }
    @IBAction func actDone(_ sender: Any) {
        post()
    }
    
    // 빈 화면 터치 시 입력 닫기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func post(){
            // DB에 저장
            guard let title = txtFldName.text,
                  let category = txtFldCategory.text,
                  let place = txtFldPlace.text,
                  let latitude = latitude,
                  let longitude = longitude,
                  let description = txtFldDescription.text
            else { return }
            var startDate = datePickerStartDate.date.toString()
            var idx = startDate.index(startDate.startIndex, offsetBy: 9)
            startDate = String(startDate[...idx])
            var endDate = datePickerEndDate.date.toString()
            idx = endDate.index(endDate.startIndex, offsetBy: 9)
            endDate = String(endDate[...idx])
            
            let bodyData : [String: Any] = [
                "businessusersId" : "2020-2020-1234",
                "name"            : title,
                "category"        : category,
                "place"           : place,
                "location"        : [ "type": "Point",
                                      "coordinates": [latitude, longitude] ],
                "startdate"       : startDate,
                "enddate"         : endDate,
                "description"     : description,
                "isPromotional"   : false,
                "needSellers"     : false
            ]
            postMarketData( collection: "markets", body: bodyData)
      
        
            // alert
            let alert = UIAlertController(title: "저장되었습니다", message: "", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "확인", style: .default, handler: { _ in
                //화면전환
                self.tabBarController?.selectedIndex = 0
     
            })
            alert.addAction(actionOK)
            present(alert, animated: true)
    }
    
    // 입력 확인(타이틀, 카테고리, 장소) 후 버튼 활성화 함수
    func enableAddBtn(){
        if txtFldName.text != "" && txtFldCategory.text != "" && txtFldPlace.text != ""
        {
            btnDone.isEnabled = true
            print("--버튼 활성화--")
            return
        }
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


