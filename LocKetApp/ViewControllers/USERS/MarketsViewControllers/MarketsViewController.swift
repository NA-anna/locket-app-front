//
//  MarketsViewController.swift
//  LocketApp
//
//  Created by 나유진 on 2022/11/20.
//
  
import UIKit

class MarketsViewController: UITableViewController {


    var category = "" //카테고리
    var pMarkets = markets
    var searchFlag: Bool = false
    var searchedMarkets = markets
    

    @IBOutlet var navigationTitle: UINavigationItem!
    @IBOutlet var searchBar: UISearchBar!
    var paramText: String = "" {
        didSet{
            search(with: paramText)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style
        self.navigationController?.navigationBar.topItem?.title = ""  // 내비게이션바 back 문구 지우기
        self.searchBar.text = paramText
        
        
        // <부모화면에서 전달받은 category 매개변수에 따라 데이터 분기>
        if category == "ALL"{
            pMarkets = markets
           
        // 모집중인 마켓만 필터
        }else if category == "모집중"{
            self.pMarkets = markets.filter { market in
                return market.isGathering() == true
            }
            
        // 카테고리에 따라서 마켓 필터
        }else if category != ""{
            self.pMarkets = markets.filter { market in
                return market.category == self.category
            }
        }
        
        navigationTitle.title = self.category
        
    }
    
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchFlag {
            return searchedMarkets.count
        }else{
            return pMarkets.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "marketcell", for: indexPath) as? MarketsCell else { return UITableViewCell() }
        
        
        var market = pMarkets[indexPath.row]
        if self.searchFlag {
            market = searchedMarkets[indexPath.row]
        }
        
        
        cell.setValues(market: market, index : indexPath.row)

        return cell
    }
    


 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? MarketDetailViewController
        
        
        if let index = tableView.indexPathForSelectedRow?.row {
            
            vc?.market = pMarkets[index]
            
        }
    }


    
    //===========================================================================================
    // Function - filter
    //===========================================================================================
    func search(with query : String?){
        guard let query = query //searchBar.text
        else { return }
        
        self.searchFlag = false
        if query != "" {
            searchedMarkets = pMarkets
            searchedMarkets = searchedMarkets.filter { market in
                return market.name.contains(query)
            }
            self.searchFlag = true
        }
        
        
        tableView.reloadData()
    }
        
}



//===========================================================================================
// Extension 확장
//===========================================================================================

// UI SEARCH BAR 프로토콜
extension MarketsViewController: UISearchBarDelegate {
    
    // MARK: - UISearchBar Delegate

    // [검색]버튼 클릭 시
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        search(with: searchBar.text)
        
        searchBar.resignFirstResponder()
    }
}
