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

    
/*
    // URL -> URLRequest
    func searchPlaceApi(with query: String?, page: Int){  //외부 매개변수로 with를 쓰는게 관례적
        guard let query = query else { return }
        self.page = page
        
        // 1 url
        let str = "https://dapi.kakao.com/v2/local/search/keyword.JSON?query=\(query)&page=\(page)"
        
        // url 엔코딩
        guard let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: strURL) else { return }
            
        // 2 URLRequest
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization") // Header 추가
        let session = URLSession.shared
        
        //3 작업 단위 만들기
        // 시간이 오래걸리는 작업은 자동으로 글로벌큐로 보내버림
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {return}
            
            // 4 Parsing
            do{
                let root = try JSONDecoder().decode(ResultData.self, from: data)
                self.documents = root.documents
                print(self.documents)
                
                DispatchQueue.main.async() {
                    //thread 가 글로벌 큐에서 작업중이어서 main에 비동기로 보낸다 (UI는 main thread에서 작업)
                    self.tableView.reloadData()
                  //  self.btnNext.isEnabled = !root.meta.is_end
                }
                 
            }catch {
                print("파싱실패")
            }
        }
        task.resume() //만든 작업단위를 실행해라
        
       // btnPrev.isEnabled = page > 1
    }
    
*/
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        dismiss(animated: true)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddViewController_place: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        callApiForPlace(with: searchBar.text) // -> 전역변수 placePublicData: ResultData? 에 데이터 저장
        
        guard let resultData = placePublicData, let documents = resultData.documents else {return}
        self.documents = documents
        DispatchQueue.main.async() {
            //thread 가 글로벌 큐에서 작업중이어서 main에 비동기로 보낸다 (UI는 main thread에서 작업)
            self.tableView.reloadData()  
        }
        
        searchBar.resignFirstResponder()
    }
}
