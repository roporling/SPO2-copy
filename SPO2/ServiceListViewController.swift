//
//  DeviceConfigViewController.swift
//  SPO2
//
//  Created by Dean Teng on 2018/8/3.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//

import UIKit
import CoreBluetooth

class BTServiceInfo{
    var service: CBService!
    var characteristics: [CBCharacteristic]
    init(service: CBService, characteristics: [CBCharacteristic]) {
        self.service = service
        self.characteristics = characteristics
    }
}


class ServiceListViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManger: CBCentralManager!
    var peripheral: CBPeripheral!
    
    var BTDeviceName:String!
    
    @IBOutlet weak var bbConnect: UIBarButtonItem!
    
    
    var btServices: [BTServiceInfo] = []
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("central state:\(central.state.rawValue)")
    }
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CharacteristicCell", bundle: nil), forCellReuseIdentifier: "CharacteristicCell")
        
        navigationItem.title=BTDeviceName
        
        peripheral.delegate=self
        centralManger.delegate = self
        centralManger.connect(peripheral, options: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        btServices = []
        
        if peripheral.state == CBPeripheralState.connected{
            bbConnect.title = "Connected"
            bbConnect.isEnabled = false
        }
        
       print()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        centralManger.delegate = self
        peripheral.delegate = self
        tableView.reloadData()
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        if peripheral.state == CBPeripheralState.connected {
            bbConnect.title = "Connected"
            bbConnect.isEnabled = false
            peripheral.discoverServices(nil)
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for serviceObj in peripheral.services!{
            let service:CBService = serviceObj
            let isServiceIncluded = self.btServices.filter({ (item: BTServiceInfo) -> Bool in
                return item.service.uuid == service.uuid
            }).count
            if isServiceIncluded == 0{
                btServices.append(BTServiceInfo(service: service, characteristics: []))
            }
            
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        let serviceCharacteristics = service.characteristics
        
        for item in btServices {
            if item.service.uuid == service.uuid {
                item.characteristics = serviceCharacteristics!
                break
            }
        }
        
        tableView.reloadData()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return btServices[section].service.uuid.description
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*let cell: CharacteristicCell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicCell") as! CharacteristicCell*/
        let cell:CharacteristicCell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicCell") as! CharacteristicCell
        
        cell.btUUID.text = btServices[indexPath.section].characteristics[indexPath.row].uuid.uuidString
        
        cell.btDESC.text = btServices[indexPath.section].characteristics[indexPath.row].uuid.description
        
        cell.btProperites.text = String(format: "0x%02X", btServices[indexPath.section].characteristics[indexPath.row].properties.rawValue)
        
        cell.btValue.text = btServices[indexPath.section].characteristics[indexPath.row].value?.description ?? "null"
        
        cell.btNotification.text =  btServices[indexPath.section].characteristics[indexPath.row].isNotifying.description
        
        cell.btPropertyContent.text = btServices[indexPath.section].characteristics[indexPath.row].getPropertyContent()
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    
    
     /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }*/
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return btServices.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return btServices[section].characteristics.count
    }

   
}
