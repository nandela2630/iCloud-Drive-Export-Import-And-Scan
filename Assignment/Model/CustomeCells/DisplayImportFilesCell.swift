//
//  DisplayImportFilesCell.swift
//  Assignment
//
//  Created by JMRIMAC-1 on 4/26/18.
//  Copyright © 2018 JMRIMAC-1. All rights reserved.
//

import UIKit

class DisplayImportFilesCell: UITableViewCell {

    @IBOutlet weak var dispImgVW: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var filleExtension: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
