//
//  BeaconsVC.swift
//  CoreBluetoothDemo
//


import UIKit
import CoreBluetooth

class BeaconsVC: UIViewController {

    @IBOutlet weak var buttonScan: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelData: UILabel!

    var centralManager: CBCentralManager?
    var tableViewManager = DeviceListTableViewManager()

    var peripherals: [CBPeripheral] = []
    var discoveredPeripheral: CBPeripheral?

    override func viewDidLoad() {
        super.viewDidLoad()

        startCentralManager()

        tableViewManager.actionListener = self
        tableViewManager.setupTableView(tableView)
    }

    func startCentralManager() {
        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn) {
            self.startScan()
        } else {
            print("bluetooth off")
        }
    }

    func startScan() {
        print("Start scanning")

        self.centralManager?.scanForPeripherals(
            withServices: nil, options:  [
                CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: false as Bool)
            ])

        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(stopScan), userInfo: nil, repeats: false)
    }

    @objc func stopScan() {
        print("Stop scanning")
        buttonScan.setTitle("Scan", for: .normal)
        self.centralManager?.stopScan()
    }

    func connectToPeripheral(_ peripheral: CBPeripheral) {
        self.centralManager?.connect(peripheral, options: nil)
    }

    internal func cancelPeripheralConnection() {
        if let peripheral = self.discoveredPeripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }

    fileprivate func cleanup() {
        peripherals.removeAll()

        guard self.discoveredPeripheral?.state == .connected else {
            return
        }
        guard let services = self.discoveredPeripheral?.services else {
            cancelPeripheralConnection()
            return
        }

        for service in services {
            guard let characteristics = service.characteristics else {
                continue
            }

            for characteristic in characteristics {
                if characteristic.uuid.isEqual(measuresCharacteristicUUID) && characteristic.isNotifying {
                    discoveredPeripheral?.setNotifyValue(false, for: characteristic)
                    return
                }

            }
        }

        cancelPeripheralConnection()
    }

    @IBAction func didPressScanButton(_ sender: UIButton) {
        if (centralManager?.isScanning)! {
            self.stopScan()
            self.buttonScan.setTitle("Scan", for: .normal)
        } else {
            self.startScan()
            self.buttonScan.setTitle("Scanning", for: .normal)
        }
    }

}


extension BeaconsVC: CBCentralManagerDelegate, CBPeripheralDelegate {

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        print("Discovered \(String(describing: peripheral.name)) at \(RSSI)")

        var unique = true

        for detectedPeripheral in peripherals {
            if detectedPeripheral.identifier == peripheral.identifier {
                unique = false
            }
        }

        if unique {
            peripherals.append(peripheral)

            self.tableViewManager.updateTableView(tableView: tableView, withDeviceList: peripherals)

        }

    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        self.stopScan()

        print("Peripheral Connected")

        self.discoveredPeripheral = peripheral

        peripheral.delegate = self

        peripheral.discoverServices(nil)


    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            self.cleanup()
            return
        }

        guard let services = peripheral.services else {
            return
        }

        for service in services {

            peripheral.discoverCharacteristics(nil, for: service)

        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            self.cleanup()
            return
        }

        guard service.characteristics != nil else {
            return
        }

    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }

    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {

        if (characteristic.isNotifying) {
            print("Notification began on \(characteristic)")
        } else {
            print("Notification stopped on (\(characteristic))")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {

        print("Peripheral Disconnected")
        self.cleanup()
    }
}


extension BeaconsVC: DeviceListTableViewDelegate {

    func didSelectDevice(_ device: CBPeripheral) {
        connectToPeripheral(device)
    }

}
