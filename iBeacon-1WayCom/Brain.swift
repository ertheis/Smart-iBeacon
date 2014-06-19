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
    let channel = PNChannel.channelWithName("minor:6major:9ChangeThisSuffix", shouldObservePresence: true) as PNChannel
    
    var serverStatus = UILabel()
    
    init(){
        super.init()
    }
    
    func setup(serverLabel: UILabel) {
        PubNub.setDelegate(self)
        PubNub.setConfiguration(self.config)
        PubNub.connect()
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
        /*
        println("Join: \(PNPresenceEventType.Join.value)")
        println("Leave: \(PNPresenceEventType.Leave.value)")
        println("Changed: \(PNPresenceEventType.Changed.value)")
        println("Timeout: \(PNPresenceEventType.Timeout.value)")
        println("State Change: \(PNPresenceEventType.StateChanged.value)")
        println("Event Type: \(event.type.value)")
        */
        if(event.type.value == PNPresenceEventType.Join.value) {
            PubNub.sendMessage("Free Latte!", toChannel: event.channel)
            println("Message Sent")
        } else if (event.type.value == PNPresenceEventType.Leave.value) {
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