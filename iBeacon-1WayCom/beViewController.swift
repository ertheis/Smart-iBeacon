//
//  beViewController.swift
//  iBeacon-alpha2
//
//  Created by Eric Theis on 6/11/14.
//  Copyright (c) 2014 PubNub. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class beViewController: UIViewController, CBPeripheralManagerDelegate {

    @IBOutlet var uuid : UILabel!
    @IBOutlet var major : UILabel!
    @IBOutlet var minor : UILabel!
    @IBOutlet var identity : UILabel!
    @IBOutlet var beaconStatus : UILabel!
    @IBOutlet var serverStatus : UILabel!
    
    let uuidObj = NSUUID(UUIDString: "0CF052C2-97CA-407C-84F8-B62AAC4E9020")
    
    var region = CLBeaconRegion()
    var data = NSDictionary()
    var manager = CBPeripheralManager()
    
    var brain = Brain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.region = CLBeaconRegion(proximityUUID: uuidObj, major: 9, minor: 6, identifier: "com.pubnub.test")
        updateInterface()
        
        brain.setup(self.serverStatus, minor: self.region.minor, major: self.region.major)
    }
    
    func updateInterface(){
        self.uuid.text = self.region.proximityUUID.UUIDString
        self.major.text = "\(self.region.major)"
        self.minor.text = "\(self.region.minor)"
        self.identity.text = self.region.identifier
    }
    
    @IBAction func transmitBeacon(sender : UIButton) {
        self.data = self.region.peripheralDataWithMeasuredPower(nil)
        self.manager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if(peripheral.state == CBPeripheralManagerState.PoweredOn) {
            println("powered on")
            println(data)
            self.manager.startAdvertising(data)
            self.beaconStatus.text = "Transmitting!"
        } else if(peripheral.state == CBPeripheralManagerState.PoweredOff) {
            println("powered off")
            self.manager.stopAdvertising()
            self.beaconStatus.text = "Power Off"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
