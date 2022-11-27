//
//  AppliedListViewController.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/27.
//

import UIKit

class AppliedListViewController: UITableViewController {
    
    //Azure Storage 설정 세팅
    var blobstorage: AZBlobService = AZBlobService.init(connectionString, containerName: "sellerprofile")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {return}
        let userId = user.id
        
        getSeller(userId: userId) {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath)

        
        blobstorage.downloadImage(blobName: "한강달빛야시장_fd480dd0-8771-4a3d-bc60-8640f34eb6fb_heungmin7", handler: { data in
            let image = UIImage(data: data)
            
            let imageView = tableView.viewWithTag(1) as? UIImageView
            imageView?.image = image
        })
        

        return cell
    }
    



    

}
