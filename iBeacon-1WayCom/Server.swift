//
//  Server.swift
//  iBeacon-1WayCom
//
//  Created by Eric Theis on 6/16/14.
//  Copyright (c) 2014 PubNub. All rights reserved.
//

import UIKit

class Server: NSObject, PNDelegate {
    let config = PNConfiguration(forOrigin: "pubsub.pubnub.com", publishKey: "demo", subscribeKey: "demo", secretKey: nil)
    
    var channel: PNChannel
    var beaconStatus = UILabel()
    var keepSending = true
    
    init(){
        channel = PNChannel()
        super.init()
    }
    
    func setStatusLabel(beaconLabel: UILabel) {
        self.beaconStatus = beaconLabel
    }
    
    func setChannel(major: NSNumber, minor: NSNumber) {
        channel = PNChannel.channelWithName("\(major)\(minor)ChangeThisSuffix", shouldObservePresence: true) as PNChannel
        PubNub.subscribeOnChannel(channel)
    }
    
    func sendDeals() {
        PubNub.sendMessage("Free Latte!", toChannel: channel)
    }
    
    func pubnubClient(client: PubNub!, didConnectToOrigin origin: String!) {
        println("DELEGATE: connected to origin \(origin)")
        self.beaconStatus.text = "Connected to PubNub"
    }
    
    func pubnubClient(client: PubNub!, didSubscribeOnChannels channels: NSArray!) {
        println("DELEGATE: Subscribed to channel(s): \(channels)")
        self.beaconStatus.text = "Ready to transmit"
    }
    
    func pubnubClient(client: PubNub!, didReceivePresenceEvent event: PNPresenceEvent!) {
        println("Join: \(PNPresenceEventType.Join.value)")
        println("Leave: \(PNPresenceEventType.Leave.value)")
        println("Changed: \(PNPresenceEventType.Changed.value)")
        println("Timeout: \(PNPresenceEventType.Timeout.value)")
        println("State Change: \(PNPresenceEventType.StateChanged.value)")
        println("Event Type: \(event.type.value)")
        /*
        if(event.type.value == PNPresenceEventType.Join.value){
            PubNub.sendMessage("Free Latte!", toChannel: event.channel)
            println("Message Sent")
        } else if (event.type.value == PNPresenceEventType.Leave.value) {
            println("they left")
        }*/
    }
    
    func pubnubClient(client: PubNub!, didReceiveMessage message: PNMessage!){
        println("message received: \(message.message)")
    }
    
    func pubnubClient(client: PubNub!, didUnsubscribeOnChannels channels: NSArray!) {
        println("DELEGATE: Unsubscribed channel(s): \(channels)")
        self.beaconStatus.text = "Unsubscribed"
    }
    
    func pubnubClient(client: PubNub!, didDisconnectFromOrigin origin: String!) {
        println("Disconnected")
        self.beaconStatus.text = "Disconnected"
    }
    
    func pubnubClient(client: PubNub!, didSendMessage message: PNMessage!) {
        println("sent message on channel: \(channel.description)")
    }
    
    func pubnubClient(client: PubNub!, didFailMessageSend message: PNMessage!, withError error: PNError!) {
        println(error.description)
    }
}