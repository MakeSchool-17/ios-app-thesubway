//
//  TournamentCell.swift
//  TournaMake
//
//  Created by Dan Hoang on 12/29/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class TournamentCell: UITableViewCell {

    @IBOutlet var labelName : UILabel!
    @IBOutlet var labelFormat : UILabel!
    @IBOutlet var labelEntrantNum : UILabel!
    @IBOutlet var labelCreationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
