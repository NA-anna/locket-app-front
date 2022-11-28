//
//  FiveMarketsCell.swift
//  LocKetApp
//
//  Created by yeonji on 2022/11/28.
//

import UIKit

class FiveMarketsCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var place: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var descrip: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 7
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
