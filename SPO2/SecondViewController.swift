//
//  SecondViewController.swift
//  SPO2
//
//  Created by 唐丁元 on 2018/7/18.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//

import UIKit
import Charts
import SQLite

class SecondViewController: UIViewController {
   
    
    var database:Connection!
    
    let dataTable = Table("data")
    let id = Expression<Int>("id")
    let dateTime = Expression<String>("dateTime")
    let spo2 = Expression<String>("spo2")
    let pulse = Expression<String>("pulse")
    
    @IBOutlet weak var LineChartView: LineChartView!
    
    
    @IBOutlet weak var HeartRateView: LineChartView!
    
    
    @IBOutlet weak var DateTextField: UITextField!
    
    private var datePicker:UIDatePicker?
    
    
    
    override func viewDidLoad() {
        
       
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch{
            print(error)
        }
        
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        DateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(SecondViewController.dateChange(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SecondViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view, typically from a nib.
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
    }
   //
    override func viewDidAppear(_ animated: Bool) {
        setChartValues()
        setHeartRateValues()
    }
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChange(datePicker:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="MM/dd/yyyy"
        DateTextField.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
        
    }
    
    
    
    
    
    func setChartValues(){
        
        do{
            let checkItems = try database.prepare(dataTable)
            
            for Items in checkItems {
                print("data id:\(Items[id]), dateTime:\(Items[dateTime]), spo2:\(Items[spo2]), pulse:\(Items[pulse])" + " !VC2!")
                let values = (0..<Int(Items[id])).map{(i)->ChartDataEntry in
                    let val = Items[spo2]
                    return ChartDataEntry(x:Double(i), y:Double(val)!)
                }
                let set1 = LineChartDataSet(values: values, label:"SPO2")
                let data = LineChartData(dataSet: set1)
                
                LineChartView.leftAxis.axisMinimum=80
                LineChartView.leftAxis.axisMaximum=110
                LineChartView.rightAxis.enabled=false
                LineChartView.xAxis.labelPosition=XAxis.LabelPosition.bottom
                //xAxis grid
                LineChartView.xAxis.drawGridLinesEnabled=false
                LineChartView.dragXEnabled = true
                //yAxis grid
                //LineChartView.leftAxis.drawGridLinesEnabled=false
                set1.drawCirclesEnabled=true
                LineChartView.backgroundColor=UIColor.white
                
                self.LineChartView.data = data
                
                LineChartView.doubleTapToZoomEnabled=false
                
                
            }
            
        } catch{
            print(error)
        }
       
    }

   
    
    func setHeartRateValues(_ count :Int=25){
        
        let values = (0..<count).map{(i)->ChartDataEntry in
            let val = Double(arc4random_uniform(UInt32(count))+80)
            return ChartDataEntry(x:Double(i),y:val)
        }
        let set1 = LineChartDataSet(values: values, label:"HeartRate")
        let data = LineChartData(dataSet: set1)
        
        
        HeartRateView.leftAxis.axisMinimum=50
        HeartRateView.leftAxis.axisMaximum=120
        HeartRateView.rightAxis.enabled=false
        HeartRateView.xAxis.labelPosition=XAxis.LabelPosition.bottom
        HeartRateView.xAxis.drawGridLinesEnabled=false
        HeartRateView.dragXEnabled = true
        set1.drawCirclesEnabled=true
        HeartRateView.backgroundColor=UIColor.white
        
        self.HeartRateView.data=data
        
        HeartRateView.doubleTapToZoomEnabled=false
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


}

