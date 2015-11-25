//
//  StartTableViewCell.swift
//  OnTheWay
//
//  Created by Carli Lessard on 9/27/15.
//  Copyright (c) 2015 Carli Lessard. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var tableCellData: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
