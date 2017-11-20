//
//  BTLECentralViewController.swift
//  CoreBluetoothDemo
//


import UIKit
import CoreBluetooth

/// 中心设备示例-手机App通常担任的角色。
class BTLECentralViewController: UIViewController {
    
    @IBOutlet fileprivate weak var textView: UITextView!
    
    fileprivate var centralManager: CBCentralManager?
    fileprivate var discoveredPeripheral: CBPeripheral?
    
    // And somewhere to store the incoming data
    fileprivate let data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start up the CBCentralManager 创建中心管理器并设定代理者
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("Stopping scan")
        centralManager?.stopScan()
    }
}


// MARK: - 扫描外设
extension BTLECentralViewController: CBCentralManagerDelegate {
    
    /** 判断中心设备的蓝牙状态
     *  centralManagerDidUpdateState is a required protocol method.
     *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
     *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
     *
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("\(#line) \(#function)")
        
        guard central.state != .unsupported else {
            debugPrint("该设备不支持蓝牙.")
            return
        }
        
        guard central.state == .poweredOn else {
            debugPrint("蓝牙已关闭.")
            return
        }
        
        // The state must be CBCentralManagerStatePoweredOn...
        scan()
    }
    
    /** Scan for peripherals - specifically for our service's 128bit CBUUID
     */
    func scan() {
        /// 根据SERVICE_UUID来扫描外设，如果不设置SERVICE_UUID，则扫描所有蓝牙设备
        centralManager?.scanForPeripherals(
            withServices: [transferServiceUUID], options: [
                CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true as Bool)
            ]
        )
        
        debugPrint("Scanning started")
    }
    
    /** 扫描到外设后回调
     *  This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
     *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is, we start the connection process
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Reject any where the value is above reasonable range
        // Reject if the signal strength is too low to be close enough (Close is around -22dB)
        
        //        if  RSSI.integerValue < -15 && RSSI.integerValue > -35 {
        //            println("Device not at correct range")
        //            return
        //        }
        
        debugPrint("Discovered \(String(describing: peripheral.name)) at \(RSSI)")
        
        // 可以根据外设名字来过滤外设
        if (peripheral.name?.hasPrefix("Test"))! {}
        
        // Ok, it's in range - have we already seen it?
        
        if discoveredPeripheral != peripheral {
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            discoveredPeripheral = peripheral
            
            // And connect
            debugPrint("Connecting to peripheral \(peripheral)")
            // 连接外设
            centralManager?.connect(peripheral, options: nil)
        }
    }
    
    /** 连接失败的回调
     *  If the connection fails for whatever reason, we need to deal with it.
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        debugPrint("Failed to connect to \(peripheral). (\(error!.localizedDescription))")
        
        cleanup()
    }
    
    /** 连接成功
     *   We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
     *   当连接成功的时候，就会来到下面这个方法。为了省电，当连接上外设之后，就让中心设备停止扫描，并设置连接上的外设的代理。在这个方法里根据UUID进行服务的查找。
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Peripheral Connected")
        
        // Stop scanning
        centralManager?.stopScan()
        print("Scanning stopped")
        
        // Clear the data that we may already have
        data.length = 0
        
        // 设置代理 Make sure we get the discovery callbacks
        peripheral.delegate = self
        
        // 根据UUID来寻找服务 Search only for services that match our UUID
        peripheral.discoverServices([transferServiceUUID])
    }
    
    /** 断开连接
     *   Once the disconnection happens, we need to clean up our local copy of the peripheral
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral Disconnected")
        // 断开连接可以设置重新连接
        discoveredPeripheral = nil
        
        // We're disconnected, so start scanning again
        scan()
    }
}


// MARK: - 遍历服务，找到需要的服务及相关特征
extension BTLECentralViewController: CBPeripheralDelegate {
    
    /** 发现服务
     *   The Transfer Service was discovered
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            cleanup()
            return
        }
        
        guard let services = peripheral.services else {
            return
        }
        
        // Discover the characteristic we want...
        
        /// 遍历出外设中所有的服务 Loop through the newly filled peripheral.services array, just in case there's more than one.
        for service in services {
            /// 根据UUID寻找服务中的特征
            peripheral.discoverCharacteristics([transferCharacteristicUUID], for: service)
        }
    }
    
    /** 发现特征回调 The Transfer characteristic was discovered.
     *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Deal with errors (if any)
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            cleanup()
            return
        }
        
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        /// 遍历出所需要的特征 Again, we loop through the array, just in case.
        for characteristic in characteristics {
            // And check if it's the right one
            if characteristic.uuid.isEqual(transferCharacteristicUUID) {
                /// 直接读取这个特征数据，会调用didUpdateValueForCharacteristic
                peripheral.readValue(for: characteristic)
                
                /// 订阅(subscribe)通知-监控外设中这个特征值得变化了
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        // Once this is complete, we just need to wait for the data to come in.
    }
    
    /** 接收到数据回调
     *  外设可以发送数据给中心设备，中心设备也可以从外设读取数据，当发生这些事情的时候，就会回调这个方法。通过特种中的value属性拿到原始数据，然后根据需求解析数据。
     *  This callback lets us know more data has arrived via notification on the characteristic
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let stringFromData = String(data: characteristic.value!, encoding: .utf8) else {
            print("Invalid data")
            return
        }
        
        // Have we got everything we need?
        if stringFromData.isEqual("EOM") {
            // We have, so show the data,
            textView.text = String(data: data.copy() as! Data, encoding: .utf8)
            
            // Cancel our subscription to the characteristic
            peripheral.setNotifyValue(false, for: characteristic)
            
            // and disconnect from the peripehral
            centralManager?.cancelPeripheralConnection(peripheral)
        } else {
            // Otherwise, just add the data on to what we already have
            data.append(characteristic.value!)
            
            // Log it
            print("Received: \(stringFromData)")
        }
    }
    
    /** 订阅状态改变回调
     *  The peripheral letting us know whether our subscribe/unsubscribe happened or not
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("Error changing notification state: \(String(describing: error?.localizedDescription))")
        
        // Exit if it's not the transfer characteristic
        guard characteristic.uuid.isEqual(transferCharacteristicUUID) else {
            return
        }
        
        // Notification has started
        if (characteristic.isNotifying) {
            print("Notification began on \(characteristic)")
        } else { // Notification has stopped
            print("Notification stopped on (\(characteristic)) Disconnecting")
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    /** Call this when things either go wrong, or you're done with the connection.
     *  This cancels any subscriptions if there are any, or straight disconnects if not.
     *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
     */
    fileprivate func cleanup() {
        // Don't do anything if we're not connected
        // self.discoveredPeripheral.isConnected is deprecated
        guard discoveredPeripheral?.state == .connected else {
            return
        }
        
        // See if we are subscribed to a characteristic on the peripheral
        guard let services = discoveredPeripheral?.services else {
            cancelPeripheralConnection()
            return
        }
        
        for service in services {
            guard let characteristics = service.characteristics else {
                continue
            }
            
            for characteristic in characteristics {
                if characteristic.uuid.isEqual(transferCharacteristicUUID) && characteristic.isNotifying {
                    discoveredPeripheral?.setNotifyValue(false, for: characteristic)
                    // And we're done.
                    return
                }
            }
        }
    }
    
    fileprivate func cancelPeripheralConnection() {
        // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
        centralManager?.cancelPeripheralConnection(discoveredPeripheral!)
    }
}

