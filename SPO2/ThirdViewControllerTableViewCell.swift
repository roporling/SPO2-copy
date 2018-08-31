//
//  ThirdViewControllerTableViewCell.swift
//  SPO2
//
//  Created by 唐丁元 on 2018/7/25.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//

import UIKit

class ThirdViewControllerTableViewCell: UITableViewCell {

   
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var SPO2Label: UILabel!
    @IBOutlet weak var PulseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
