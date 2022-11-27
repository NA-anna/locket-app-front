//
//  AddViewController.swift
//  miniProject01
//
//  Created by 나유진 on 2022/10/26.
//

import UIKit

class AddViewController: UIViewController {
    
    var category: String?{
        didSet(oldValue){
        }willSet(newValue){
            txtFldCategory.text = newValue
            enableAddBtn()
        }
    }
    var place: Document?{
        didSet(oldValue){
        }willSet(newValue){
            txtFldPlace.text = newValue?.place_name
           // id = newValue?.id
            x = newValue?.x
            y = newValue?.y
            enableAddBtn()
        }
    }
    var x: String?
    var y: String?
    //var id: String?
    
   
    @IBOutlet var btnDone: UIBarButtonItem!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldCategory: UITextField!
    @IBOutlet var datePickerStartDate: UIDatePicker!
    @IBOutlet var datePickerEndDate: UIDatePicker!
    @IBOutlet weak var txtFldPlace: UITextField!
    @IBOutlet weak var txtFldDescription: UITextView!
    
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFldName.delegate = self //UITextFieldDelegate 프로토
        
    }

    @IBAction func tileDidEnd(_ sender: Any) {
        enableAddBtn()
    }
    
    @IBAction func actDone(_ sender: Any) {
    
        // DB에 저장
        guard let title = txtFldName.text,
              let category = txtFldCategory.text,
              let place = txtFldPlace.text,
              let x = x,
              let y = y,
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
                                  "coordinates": [x, y] ],
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
     
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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






// TextFiled [완료] 클릭 시 -> 키보드 닫기
extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("리턴")
        //최초반응자 사임..
        txtFldName.resignFirstResponder()
        return true
    }
}

