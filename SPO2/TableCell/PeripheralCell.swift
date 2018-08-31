//
//  PeripheralCell.swift
//  SPO2
//
//  Created by Dean Teng on 2018/8/2.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//

import UIKit

class PeripheralCell: UITableViewCell {

    @IBOutlet weak var BTName: UILabel!
    @IBOutlet weak var BTID: UILabel!
    @IBOutlet weak var BTConnectable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
