//
//  ThirdViewController.swift
//  SPO2
//
//  Created by 唐丁元 on 2018/7/18.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//

import UIKit
import SQLite





class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var database:Connection!
    
    let dataTable = Table("data")
    let id = Expression<Int>("id")
    let dateTime = Expression<String>("dateTime")
    let spo2 = Expression<String>("spo2")
    let pulse = Expression<String>("pulse")
    var refreshcontrol = UIRefreshControl()
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
   
    @IBOutlet weak var InformationTableView: UITableView!
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        self.InformationTableView.backgroundColor=UIColor.lightGray
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            
            
        } catch{
            print(error)
        }
      
        refreshcontrol.addTarget(self, action: #selector(ThirdViewController.refreshData), for: .valueChanged)
        refreshcontrol.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshcontrol.tintColor = UIColor.white
        refreshData()
       
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
        
        
    }
    
    @objc func refreshData(){
        print("refreshing data")
        let finish = DispatchTime.now() + .milliseconds(800)
        DispatchQueue.main.asyncAfter(deadline: finish){
            self.refreshcontrol.endRefreshing()
        }
    }
    
    
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController!.selectedIndex += 1
        }
        if sender.direction == .right {
            self.tabBarController!.selectedIndex -= 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! ThirdViewControllerTableViewCell
        do{
            let checkItems = try database.prepare(dataTable)
            
            for Items in checkItems {
                print("data id:\(Items[id]), dateTime:\(Items[dateTime]), spo2:\(Items[spo2]), pulse:\(Items[pulse])" + " !VC3!")
                
                    cell.TimeLabel.text = Items[dateTime]
                    cell.SPO2Label.text = Items[spo2]
                    cell.PulseLabel.text = Items[pulse]
                
            }
            
        } catch{
            print(error)
        }
        
        //let Information = data[indexPath.row]
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reloadInputViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
