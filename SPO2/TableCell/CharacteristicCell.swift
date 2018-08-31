//
//  CharacteristicCell.swift
//  SPO2
//
//  Created by Dean Teng on 2018/8/3.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//

import UIKit

class CharacteristicCell: UITableViewCell {

    @IBOutlet weak var btDESC: UILabel!
    @IBOutlet weak var btProperites: UILabel!
    @IBOutlet weak var btValue: UILabel!
    @IBOutlet weak var btNotification: UILabel!
    @IBOutlet weak var btUUID: UILabel!
    @IBOutlet weak var btPropertyContent: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
