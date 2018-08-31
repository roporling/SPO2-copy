//
//  ViewController3.swift
//  SPO2
//
//  Created by Dean Teng on 2018/8/3.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController3: UIViewController,CBPeripheralDelegate{

    var char: CBCharacteristic!
    var peripheral: CBPeripheral!

    @IBOutlet weak var btnRead: UIButton!
    @IBOutlet weak var BTUUID: UILabel!
    //@IBOutlet weak var BTPorp: UILabel!
    @IBOutlet weak var TVResponse: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BTUUID.text = char.uuid.uuidString
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        peripheral.delegate = self
        if !char.isReadable() {
            btnRead.isEnabled = false
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            TVResponse.text = (data.getByteArray()?.description)! + "\n" + TVResponse.text
        }
    }
    
    

    @IBAction func Read(_ sender: Any) {
        peripheral.readValue(for: char)
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
