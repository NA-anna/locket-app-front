//
//  MenuViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/12/07.
//

import UIKit

class MenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let symbol = cell.viewWithTag(1) as? UIImageView
        let label = cell.viewWithTag(2) as? UILabel
        
        switch indexPath.row{
        case 0:
            symbol?.image = UIImage(systemName: "bell")
            symbol?.tintColor = .label
            label?.text = "마켓 등록하기"
            
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            let storyBoard = UIStoryboard(name: "AddingSt", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "addingSt")
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
