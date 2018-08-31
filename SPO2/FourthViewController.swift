//
//  FourthViewController.swift
//  SPO2
//
//  Created by 唐丁元 on 2018/7/18.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//

import UIKit


var optionData=[OptionList(headerName: "Bluetooth", subType: ["Turn On Bluetooth","Match to machine"], isExpandable: false),
                OptionList(headerName: "Healthcare Management Platform", subType: ["Log in","Data Backup","Open Healthcare Management Platorm","Data download"], isExpandable: false),
                OptionList(headerName: "Delete History Data", subType: [], isExpandable: false)
]



class FourthViewController: UIViewController {

    @IBOutlet weak var OptionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.OptionTableView.backgroundColor = UIColor.lightGray
        
        OptionTableView.tableFooterView=UIView()
        // Do any additional setup after loading the view, typically from a nib.
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController!.selectedIndex += 1
        }
        if sender.direction == .right {
            self.tabBarController!.selectedIndex -= 1
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FourthViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Header(frame: CGRect(x: 0, y: 0, width: OptionTableView.frame.size.width, height: 40))
        headerView.delegate = self
        headerView.secIndex=section
        headerView.btn.setTitle(optionData[section].headerName, for: .normal)
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return optionData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if optionData[section].isExpandable{
            return optionData[section].subType.count
        }else{
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = optionData[indexPath.section].subType[indexPath.row]
        return cell!
    }
    
    
}

extension FourthViewController:HeaderDelegate{
    func callHeader(idx: Int) {
        optionData[idx].isExpandable = !optionData[idx].isExpandable
        OptionTableView.reloadSections([idx], with: .automatic)
    }
    
    
}

