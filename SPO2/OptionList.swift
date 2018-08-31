//
//  OptionList.swift
//  SPO2
//
//  Created by 唐丁元 on 2018/7/26.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//

import Foundation

class OptionList{
    var headerName:String?
    var subType = [String]()
    var isExpandable:Bool = false

    init(headerName:String, subType:[String], isExpandable:Bool){
        self.headerName=headerName
        self.subType=subType
        self.isExpandable=isExpandable
    }
}

