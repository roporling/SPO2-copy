//
//  Extension.swift
//  SPO2
//
//  Created by Dean Teng on 2018/8/3.
//  Copyright © 2018年 DeanTeng. All rights reserved.
//

import Foundation
import CoreBluetooth

extension CBCharacteristic {
    
    func isWritable() -> Bool {
        return (self.properties.intersection(CBCharacteristicProperties.write)) != []
    }
    
    func isReadable() -> Bool {
        return (self.properties.intersection(CBCharacteristicProperties.read)) != []
    }
    
    func isWritableWithoutResponse() -> Bool {
        return (self.properties.intersection(CBCharacteristicProperties.writeWithoutResponse)) != []
    }
    
    func isNotifable() -> Bool {
        return (self.properties.intersection(CBCharacteristicProperties.notify)) != []
    }
    
    func isIdicatable() -> Bool {
        return (self.properties.intersection(CBCharacteristicProperties.indicate)) != []
    }
    
    func isBroadcastable() -> Bool {
        return (self.properties.intersection(CBCharacteristicProperties.broadcast)) != []
    }
    
    func isExtendedProperties() -> Bool {
        return (self.properties.intersection(CBCharacteristicProperties.extendedProperties)) != []
    }
    
    func isAuthenticatedSignedWrites() -> Bool {
        return (self.properties.intersection(CBCharacteristicProperties.authenticatedSignedWrites)) != []
    }
    
    func isNotifyEncryptionRequired() -> Bool {
        return (self.properties.intersection(CBCharacteristicProperties.notifyEncryptionRequired)) != []
    }
    
    func isIndicateEncryptionRequired() -> Bool {
        return (self.properties.intersection(CBCharacteristicProperties.indicateEncryptionRequired)) != []
    }
    
    
    func getPropertyContent() -> String {
        var propContent = ""
        if (self.properties.intersection(CBCharacteristicProperties.broadcast)) != [] {
            propContent += "Broadcast,"
        }
        if (self.properties.intersection(CBCharacteristicProperties.read)) != [] {
            propContent += "Read,"
        }
        if (self.properties.intersection(CBCharacteristicProperties.writeWithoutResponse)) != [] {
            propContent += "WriteWithoutResponse,"
        }
        if (self.properties.intersection(CBCharacteristicProperties.write)) != [] {
            propContent += "Write,"
        }
        if (self.properties.intersection(CBCharacteristicProperties.notify)) != [] {
            propContent += "Notify,"
        }
        if (self.properties.intersection(CBCharacteristicProperties.indicate)) != [] {
            propContent += "Indicate,"
        }
        if (self.properties.intersection(CBCharacteristicProperties.authenticatedSignedWrites)) != [] {
            propContent += "AuthenticatedSignedWrites,"
        }
        if (self.properties.intersection(CBCharacteristicProperties.extendedProperties)) != [] {
            propContent += "ExtendedProperties,"
        }
        if (self.properties.intersection(CBCharacteristicProperties.notifyEncryptionRequired)) != [] {
            propContent += "NotifyEncryptionRequired,"
        }
        if (self.properties.intersection(CBCharacteristicProperties.indicateEncryptionRequired)) != [] {
            propContent += "IndicateEncryptionRequired,"
        }
        
       /*if !propContent.isEmpty {
            //propContent = propContent.substringToIndex(propContent.endIndex.advancedBy(-1))
           
        }*/
        
        return propContent
    }
}

/*extension NSData {
    func getByteArray() -> [UInt8]? {
        var byteArray: [UInt8] = [UInt8]()
        for i in 0..<self.length {
            var temp: UInt8 = 0
            self.getBytes(&temp, range: NSRange(location: i, length: 1))
            byteArray.append(temp)
        }
        return byteArray
    }
}*/


extension Data{
    func getByteArray() -> [UInt8]?{
        var byteArray:[UInt8] =  [UInt8]()
        var temp:UInt8=0
        let irange:Range<Data.Index>=0..<self.count
        self.copyBytes(to: &temp, from: irange)
        byteArray.append(temp)
        return byteArray
    }
    
}






