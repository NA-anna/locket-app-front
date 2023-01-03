//
//  AddViewController_place.swift
//  miniProject_map
//
//  Created by 나유진 on 2022/10/27.
//

import UIKit

class AddViewController_place: UITableViewController {
    
    var documents: [Document] = []
    var parentVC: AddViewController?
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        
        let document = documents[indexPath.row]
        
        let lblPlaceName = cell.viewWithTag(1) as? UILabel
        lblPlaceName?.text = document.place_name

        let lblAdressName = cell.viewWithTag(2) as? UILabel
        lblAdressName?.text = document.address_name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let parentVC = self.parentVC else { return }
        print("데이터 전송 to parent")
        parentVC.place = documents[indexPath.row]
        navigationController?.popViewController(animated: true)
    }


}


// 서치바 검색 시 바로 파라미터가 안넘어가는 문제 해결해야 함
extension AddViewController_place: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        callApiForPlace(with: searchBar.text) // -> 전역변수 placePublicData: ResultData? 에 데이터 저장
        
        guard let resultData = placePublicData, let documents = resultData.documents else {return}
        self.documents = documents
        DispatchQueue.main.async() {
            //thread 가 글로벌 큐에서 작업중이어서 main에 비동기로 보낸다 (UI는 main thread에서 작업)
            self.tableView.reloadData()  
        }
        
        
    }
    
}


