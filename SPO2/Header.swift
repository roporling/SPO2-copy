//
//  Header.swift
//  SPO2
//
//  Created by 唐丁元 on 2018/7/26.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//

import UIKit

protocol HeaderDelegate {
    func callHeader(idx: Int)
}


class Header: UIView {
    
    
    var secIndex:Int?
    var delegate:HeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    lazy var btn:UIButton = {
        let btn = UIButton(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height))
        btn.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        btn.titleLabel?.textColor=UIColor.black
        btn.addTarget(self, action: #selector(onClickHeader), for: .touchUpInside)
        return btn
    }()

    @objc func onClickHeader(){
        if let idx = secIndex{
            delegate?.callHeader(idx: idx)
        }
    }
    
}
