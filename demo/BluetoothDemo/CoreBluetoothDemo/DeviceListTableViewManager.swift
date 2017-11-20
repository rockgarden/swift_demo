//
//  DeviceListTableViewManager.swift
//  suiff
//
//  Created by Joan Molina on 7/11/16.
//  Copyright © 2016 Identitat. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol DeviceListTableViewDelegate: class {
  func didSelectDevice(_ device: CBPeripheral)
}

final class DeviceListTableViewManager: NSObject, UITableViewDataSource, UITableViewDelegate {

  private var deviceList: [CBPeripheral] = []

  weak var actionListener: DeviceListTableViewDelegate?

  func updateTableView(tableView: UITableView, withDeviceList deviceList: [CBPeripheral]) {

    self.deviceList = deviceList
    tableView.reloadData()
  }

  func setupTableView(_ tableView: UITableView) {
    tableView.dataSource = self
    tableView.delegate = self

  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return deviceList.count
  }


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!

    let device = deviceList[indexPath.row]
    cell.textLabel?.text = device.name
   
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let deviece = deviceList[indexPath.row]
    actionListener?.didSelectDevice(deviece)
  }

}
