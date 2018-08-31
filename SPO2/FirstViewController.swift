//
//  FirstViewController.swift
//  SPO2
//
//  Created by 唐丁元 on 2018/7/18.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//
//For studying only. 

import UIKit
import WMGaugeView
import CoreBluetooth
import SQLite

var Gauge1:String?="0"

var Gauge2:String?="0"



class FirstViewController: UIViewController,CBCentralManagerDelegate, CBPeripheralDelegate{
    
    private let Service_UUID: String = "0000ffe0-0000-1000-8000-00805f9b34fb"
    private let Characteristic_UUID: String = "0000ffe1-0000-1000-8000-00805f9b34fb"
    
    @IBOutlet weak var TextField: UITextField!
    
    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var characteristic: CBCharacteristic?
    
    @IBOutlet weak var GaugeView1: WMGaugeView!
    
    @IBOutlet weak var GaugeView2: WMGaugeView!
    
    @IBOutlet weak var SPO2percent: UILabel!
    
    @IBOutlet weak var beat: UILabel!
    
   
    
    var database:Connection!
    
    let dataTable = Table("data")
    let id = Expression<Int>("id")
    let dateTime = Expression<String>("dateTime")
    let spo2 = Expression<String>("spo2")
    let pulse = Expression<String>("pulse")
    //Bluetooth connecting
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("未知的")
        case .resetting:
            print("重置中")
        case .unsupported:
            print("不支持")
        case .unauthorized:
            print("未验证")
        case .poweredOff:
            print("未启动")
        case .poweredOn:
            print("可用")
            central.scanForPeripherals(withServices: [CBUUID.init(string: Service_UUID)], options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.centralManager?.stopScan()
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID.init(string: Service_UUID)])
        print("连接成功")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // 根据外设名称来过滤
        if (peripheral.name?.hasPrefix("CC41"))! {
            self.peripheral = peripheral
            central.connect(peripheral, options: nil)
        }
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接失败")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("断开连接")
        // 重新连接
        central.connect(peripheral, options: nil)
    }
    
    /** 发现服务 */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service: CBService in peripheral.services! {
            print("外设中的服务有：\(service)")
        }
        //本例的外设中只有一个服务
        let service = peripheral.services?.last
        // 根据UUID寻找服务中的特征
        peripheral.discoverCharacteristics([CBUUID.init(string: Characteristic_UUID)], for: service!)
    }
    
    /** 发现特征 */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic: CBCharacteristic in service.characteristics! {
            print("外设中的特征有：\(characteristic)")
        }
        
        self.characteristic = service.characteristics?.last
        // 读取特征里的数据
        peripheral.readValue(for: self.characteristic!)
        // 订阅
        peripheral.setNotifyValue(true, for: self.characteristic!)
    }
    
    /** 订阅状态 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("订阅失败: \(error)")
            return
        }
        if characteristic.isNotifying {
            print("订阅成功")
        } else {
            print("取消订阅")
        }
    }
    
    
    /** 接收到数据 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let data = characteristic.value
        
        let ValueData:String = (String.init(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)))!
        if ValueData.contains("%"){
        //print(ValueData)
        let ValueArr:[String] = ValueData.components(separatedBy: "%")//(String.init(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))?.components(separatedBy: "%"))!
        print(ValueArr)
            
        let Value1 = ValueArr[0]
        let Value2 = ValueArr[1]
        
        Gauge1=String(Value1)
        Gauge2=String(Value2)
        print(Gauge1!+" SV1")
        
        print(Gauge2!+" SV2")
        insertData()
        
        }else if ValueData.contains("off"){
            let Value1 = "0"
            let Value2 = "0"
            
            Gauge1=String(Value1)
            Gauge2=String(Value2)
           // insertData()
        }
   }
    
    /** 写入数据 */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("写入数据")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch{
            print(error)
        }
        //createTable()
        
        // Do any additional setup after loading the view, typically from a nib.
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
        centralManager = CBCentralManager.init(delegate: self, queue: .main)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setGaugeValue1()
        setGaugeValue2()
        GaugeValue()
        createTable()
    }
    
    
    
    func createTable(){
        let createTable = self.dataTable.create { (table) in
            table.column(self.id, primaryKey:true)
            table.column(self.dateTime)
            table.column(self.spo2)
            table.column(self.pulse)
        }
        do {
            try self.database.run(createTable)
            print("Table Created")
        } catch{
            print(error)
        }
    }
    
    func insertData(){
        let insertData = self.dataTable.insert(self.dateTime <- getDateTime(),self.spo2 <- Gauge1!, self.pulse <- Gauge2!)
        
        do{
            try self.database.run(insertData)
            print("Data insert")
            //listoutDatabase()
        } catch{
            print(error)
        }
    }
    
    func listoutDatabase(){
        print("Data list out")
        do{
            let checkItems = try self.database.prepare(self.dataTable)
            for Items in checkItems{
                print("data id:\(Items[self.id]), dateTime:\(Items[self.dateTime]), spo2:\(Items[self.spo2]), pulse:\(Items[self.pulse])")
            }
        } catch{
            print(error)
        }
    }
    
    func getDateTime()->String{
        let now:Date = Date()
        let dateFormat:DateFormatter=DateFormatter()
        dateFormat.dateFormat="yyyy-MM-dd HH:mm:ss"
        let dateString:String = dateFormat.string(from: now)
        //print(dateString)
        return dateString
    }

  
    func setGaugeValue1(){
       //GaugeView1.innerBackgroundStyle=WMGaugeViewInnerBackgroundStyleFlat
        
        GaugeView1.showRangeLabels=true
        GaugeView1.rangeValues=[90,100]
        GaugeView1.rangeLabelsFontColor=UIColor.black
        GaugeView1.rangeLabels=["過低","正常"]
        GaugeView1.rangeColors=[UIColor.yellow,UIColor.green]
        GaugeView1.unitOfMeasurement="%"
        GaugeView1.showUnitOfMeasurement=true
        GaugeView1.maxValue=100
        GaugeView1.scaleDivisions=10
        GaugeView1.scaleStartAngle=30
        GaugeView1.scaleEndAngle=330
        
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.gauge1Update), userInfo: nil, repeats: true)
        
        //let val = Double(arc4random_uniform(UInt32(25))+70)
        //GaugeView1.setValue(Float(val), animated: true )
        
    }
    
    func setGaugeValue2(){
        GaugeView2.showRangeLabels=true
        GaugeView2.rangeValues=[60,100,120]
        GaugeView2.rangeLabelsFontColor=UIColor.black
        GaugeView2.rangeLabels=["過低","正常","過高"]
        GaugeView2.rangeColors=[UIColor.yellow, UIColor.green, UIColor.red]
        GaugeView2.unitOfMeasurement="次/分"
        GaugeView2.showUnitOfMeasurement=true
        GaugeView2.maxValue=120
        GaugeView2.scaleDivisions=12
        GaugeView2.scaleStartAngle=30
        GaugeView2.scaleEndAngle=330
       
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.gauge2Update), userInfo: nil, repeats: true)
    }
    
    func GaugeValue(){
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.GaugeChanging), userInfo: nil, repeats: true)
    }
    
    @objc func gauge1Update(){
        print(Gauge1! + " g1U")
        
            let GaugeFloat1 = (Gauge1! as NSString).floatValue
            
            GaugeView1.value = GaugeFloat1
        
        
    }
    
    @objc func gauge2Update(){
        print(Gauge2! + " g2U")
        
            let GaugeFloat2 = (Gauge2! as NSString).floatValue
            GaugeView2.value = GaugeFloat2
        
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController!.selectedIndex += 1
        }
        if sender.direction == .right {
            self.tabBarController!.selectedIndex -= 1
        }
    }
    
    @objc func GaugeChanging(){
        let tempInt1 = Int(GaugeView1.value)
        let tempInt2 = Int(GaugeView2.value)
        let percent=String(tempInt1)
        let beatperMin=String(tempInt2)
        SPO2percent.text = "血氧值: "+percent+"%"
        beat.text = "脈搏: "+beatperMin+"次/分"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


