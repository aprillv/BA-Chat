//
//  SearchItemTableViewCell.swift
//  BAChat
//
//  Created by April on 9/29/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit

class SearchItemTableViewCell: UITableViewCell {

    @IBOutlet var addressLbl: UILabel!
    
    @IBOutlet var seperatorLineHeight: NSLayoutConstraint!{
        didSet{
            seperatorLineHeight.constant = 1.0/(UIScreen.mainScreen().scale)
            self.updateConstraintsIfNeeded()
        }
    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
