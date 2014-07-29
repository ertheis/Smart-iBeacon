//
//  Server.swift
//  iBeacon-1WayCom
//
//  Created by Eric Theis on 6/16/14.
//  Copyright (c) 2014 PubNub. All rights reserved.
//

import UIKit

class Brain: NSObject, PNDelegate {
    let config = PNConfiguration(forOrigin: "pubsub.pubnub.com", publishKey: "demo", subscribeKey: "demo", secretKey: nil)
    var channel = PNChannel()
    
    var serverStatus = UILabel()
    
    init(){
        super.init()
    }
    
    func setup(serverLabel: UILabel, minor: NSNumber, major: NSNumber) {
        PubNub.setDelegate(self)
        PubNub.setConfiguration(self.config)
        PubNub.connect()
        channel = PNChannel.channelWithName("minor:\(minor)major:\(major)CompanyName", shouldObservePresence: true) as PNChannel
        PubNub.subscribeOnChannel(self.channel)
        self.serverStatus = serverLabel
    }
    
    func pubnubClient(client: PubNub!, didConnectToOrigin origin: String!) {
        self.serverStatus.text = "Connected to PubNub"
    }
    
    func pubnubClient(client: PubNub!, didSubscribeOnChannels channels: NSArray!) {
        self.serverStatus.text = "Ready to transmit"
    }
    
    func pubnubClient(client: PubNub!, subscriptionDidFailWithError error: PNError!){
        println("Subscribe Error: \(error)")
        self.serverStatus.text = "Subscription Error"
    }
    
    func pubnubClient(client: PubNub!, didUnsubscribeOnChannels channels: NSArray!) {
        self.serverStatus.text = "Unsubscribed"
    }
    
    func pubnubClient(client: PubNub!, didDisconnectFromOrigin origin: String!) {
        self.serverStatus.text = "Disconnected"
    }
    
    func pubnubClient(client: PubNub!, didReceivePresenceEvent event: PNPresenceEvent!) {
        if(event.type.toRaw() == PNPresenceEventType.Join.toRaw()) {
            PubNub.sendMessage("Free Latte!", toChannel: event.channel)
            println("Message Sent")
        } else if (event.type.toRaw() == PNPresenceEventType.Leave.toRaw()) {
            println("they left")
        }
    }
    
    func pubnubClient(client: PubNub!, didSendMessage message: PNMessage!) {
        println("sent message on channel: \(channel.description)")
    }
    
    func pubnubClient(client: PubNub!, didFailMessageSend message: PNMessage!, withError error: PNError!) {
        println(error.description)
    }
}