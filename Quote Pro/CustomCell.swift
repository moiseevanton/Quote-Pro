//
//  CustomCell.swift
//  Quote Pro
//
//  Created by Anton Moiseev on 2016-06-08.
//  Copyright © 2016 Anton Moiseev. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var upperCellLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
