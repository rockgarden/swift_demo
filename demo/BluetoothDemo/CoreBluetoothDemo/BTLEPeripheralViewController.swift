//
//  BTLEPeripheralViewController.swift
//  CoreBluetoothDemo
//


import UIKit
import CoreBluetooth

/// 外设管理器
class BTLEPeripheralViewController: UIViewController, UITextViewDelegate {
    @IBOutlet fileprivate weak var textView: UITextView!
    @IBOutlet fileprivate weak var advertisingSwitch: UISwitch!
    
    fileprivate var peripheralManager: CBPeripheralManager?
    fileprivate var transferCharacteristic: CBMutableCharacteristic?
    
    fileprivate var dataToSend: Data?
    fileprivate var sendDataIndex: Int?
    
    // First up, check if we're meant to be sending an EOM
    fileprivate var sendingEOM = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建外设管理器 Start up the CBPeripheralManager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Don't keep it going while we're not showing.
        peripheralManager?.stopAdvertising()
    }
    
    /** This is called when a change happens, so we know to stop advertising
     */
    func textViewDidChange(_ textView: UITextView) {
        // If we're already advertising, stop
        if (advertisingSwitch.isOn) {
            advertisingSwitch.setOn(false, animated: true)
            peripheralManager?.stopAdvertising()
        }
    }
}


// MARK: - 扫描外设
extension BTLEPeripheralViewController: CBPeripheralManagerDelegate {
    
    /** 判断蓝牙状态的方法Required protocol method.
     *  A full app should take care of all the possible states, but we're just waiting for  to know when the CBPeripheralManager is ready
     */
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        // Opt out from any other state
        if (peripheral.state != .poweredOn) {
            return
        }
        
        // We're in CBPeripheralManagerStatePoweredOn state...
        debugPrint("self.peripheralManager powered on.")
        
        // ... so build our service.
        setupServiceAndCharacteristics()
    }
    
    private func setupServiceAndCharacteristics() {
        /// 创建Characteristics（特征）Start with the CBMutableCharacteristic
        transferCharacteristic = CBMutableCharacteristic(
            type: transferCharacteristicUUID,
            //.notify,只有设置了这个参数，在中心设备中才能订阅这个特征。
            properties: CBCharacteristicProperties.notify,
            value: nil,
            permissions: CBAttributePermissions.readable
        )
        
        // 创建Service（服务）Then the service
        let transferService = CBMutableService(
            type: transferServiceUUID,
            primary: true
        )
        
        // 特征添加进服务 Add the characteristic to the service
        transferService.characteristics = [transferCharacteristic!]
        
        // 服务加入管理 And add it to the peripheral manager
        peripheralManager!.add(transferService)
    }
    
    /** 中心设备订阅成功回调
     *  Catch when someone subscribes to our characteristic, then start sending them data.
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        debugPrint("Central subscribed to characteristic")
        
        // Get the data
        dataToSend = textView.text.data(using: String.Encoding.utf8)
        
        // Reset the index
        sendDataIndex = 0;
        
        // Start sending
        sendData()
    }
    
    /** 中心设备取消订阅的时候回调
     *  Recognise when the central unsubscribes
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        debugPrint("Central unsubscribed from characteristic")
    }
    
    /** Sends the next amount of data to the connected central
     */
    fileprivate func sendData() {
        if sendingEOM {
            // send it
            let didSend = peripheralManager?.updateValue(
                "EOM".data(using: String.Encoding.utf8)!,
                for: transferCharacteristic!,
                onSubscribedCentrals: nil
            )
            
            // Did it send?
            if (didSend == true) {
                
                // It did, so mark it as sent
                sendingEOM = false
                
                print("Sent: EOM")
            }
            
            // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
            return
        }
        
        // We're not sending an EOM, so we're sending data
        
        // Is there any left to send?
        guard sendDataIndex < dataToSend?.count else {
            // No data left.  Do nothing
            return
        }
        
        // There's data left, so send until the callback fails, or we're done.
        var didSend = true
        
        while didSend {
            // Make the next chunk
            
            // Work out how big it should be
            var amountToSend = dataToSend!.count - sendDataIndex!;
            
            // Can't be longer than 20 bytes
            if (amountToSend > NOTIFY_MTU) {
                amountToSend = NOTIFY_MTU;
            }
            
            // Copy out the data we want
            let chunk = dataToSend!.withUnsafeBytes{(body: UnsafePointer<UInt8>) in
                return Data(
                    bytes: body + sendDataIndex!,
                    count: amountToSend
                )  
            }
            
            // Send it
            didSend = peripheralManager!.updateValue(
                chunk as Data,
                for: transferCharacteristic!,
                onSubscribedCentrals: nil
            )
            
            // If it didn't work, drop out and wait for the callback
            if (!didSend) {
                return
            }
            
            let stringFromData = NSString(
                data: chunk as Data,
                encoding: String.Encoding.utf8.rawValue
            )
            
            debugPrint("Sent: \(String(describing: stringFromData))")
            
            // It did send, so update our index
            sendDataIndex! += amountToSend;
            
            // Was it the last one?
            if (sendDataIndex! >= dataToSend!.count) {
                
                // It was - send an EOM
                
                // Set this so if the send fails, we'll send it next time
                sendingEOM = true
                
                // Send it
                let eomSent = peripheralManager!.updateValue(
                    "EOM".data(using: String.Encoding.utf8)!,
                    for: transferCharacteristic!,
                    onSubscribedCentrals: nil
                )
                
                if (eomSent) {
                    // It sent, we're all done
                    sendingEOM = false
                    debugPrint("Sent: EOM")
                }
                
                return
            }
        }
    }
    
    /// 在本地外围设备再次准备好发送特性值更新时调用
    /// This callback comes in when the PeripheralManager is ready to send the next chunk of data. This is to ensure that packets will arrive in the order they are send.
    /// 当调用updateValue（_：for：onSubscribedCentrals :)方法失败时，因为用于传输更新的特性值的基础队列已满，则在传输队列中有更多空间可用时，将调用peripheralManagerIsReady（toUpdateSubscribers :)方法。然后，您可以实现此委托方法重新发送值。
    /// - Parameter peripheral: 外围设备
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        // Start sending again
        sendData()
    }
    
    /** Start advertising
     */
    @IBAction func switchChanged(_ sender: UISwitch) {
        if advertisingSwitch.isOn {
            // 根据服务的UUID开始广播 All we advertise is our service's UUID
            peripheralManager!.startAdvertising([
                CBAdvertisementDataServiceUUIDsKey : [transferServiceUUID]
                ])
        } else {
            peripheralManager?.stopAdvertising()
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print(error ?? "UNKNOWN ERROR")
    }
}
