//
//  Services.swift
//  ExampleBeacons
//
//  Created by Joan Molina on 9/5/17.
//  Copyright © 2017 Identitat. All rights reserved.
//

import Foundation
import CoreBluetooth

//Services

let MAIN_SERVICE_UUID = "Heart Rate"
let mainServiceUUID = CBUUID(string: MAIN_SERVICE_UUID)

//Characteristics

let HEARTRATE_CHARACTERISTIC_UUID = "2A37"
let MEASURES_CHARACTERISTIC_UUID = "2A38"
let MANUFACTURER_CHARACTERISTIC_UUID = "2A39"

let heartRateCharacteristicUUID = CBUUID(string: HEARTRATE_CHARACTERISTIC_UUID)
let measuresCharacteristicUUID = CBUUID(string: MEASURES_CHARACTERISTIC_UUID)
let manufacturerCharacteristicUUID = CBUUID(string: MANUFACTURER_CHARACTERISTIC_UUID)

