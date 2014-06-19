//
//  Customer.swift
//  iBeacon-1WayCom
//
//  Created by Eric Theis on 6/16/14.
//  Copyright (c) 2014 PubNub. All rights reserved.
//

import UIKit

class Customer: NSObject, PNDelegate {
    
    let config = PNConfiguration(forOrigin: "pubsub.pubnub.com", publishKey: "demo", subscribeKey: "demo", secretKey: nil)
    
    var connected = false
    var deal = UILabel()
    var pubStatus = UILabel()
    var needDeal = true
    var subscribeAttempt = true
    
    init(){
        super.init()
    }
    
    func pubnubClient(client: PubNub!, didConnectToOrigin origin: String!) {
        println("DELEGATE: connected to origin \(origin)")
        connected = true
        self.pubStatus.text = "connected"
    }
    
    func setStatusLabel(deal: UILabel, pubStatus: UILabel) {
        self.deal = deal
        self.pubStatus = pubStatus
    }
    
    func getAdOfTheDay(major: NSNumber, minor: NSNumber) {
        println("getAd run - Connected: \(connected) subscribeAttempt: \(subscribeAttempt)")
        if(connected && subscribeAttempt) {
            subscribeAttempt = false
            var channel: PNChannel = PNChannel.channelWithName("minor:\(minor)major:\(major)ChangeThisSuffix", shouldObservePresence: true) as PNChannel
            PubNub.subscribeOnChannel(channel)
        } else if (subscribeAttempt) {
            deal.text =  "connection error :("
        }
    }
    
    func pubnubClient(client: PubNub!, didSubscribeOnChannels channels: NSArray!) {
        println("DELEGATE: Subscribed to channel(s): \(channels)")
        self.pubStatus.text = "Subscribed"
    }
    
    func pubnubClient(client: PubNub!, didReceiveMessage message: PNMessage!){
        println("message received!")
        self.pubStatus.text = "Deal Received"
        if(needDeal) {
            self.needDeal = false
            self.deal.text = "\(message.message)"
        }
        PubNub.unsubscribeFromChannel(message.channel)
    }
    
    func pubnubClient(client: PubNub!, didUnsubscribeOnChannels channels: NSArray!) {
        println("DELEGATE: Unsubscribed from channel(s): \(channels)")
        self.pubStatus.text = "Unsubscribed"
    }
    
    func pubnubClient(client: PubNub!, subscriptionDidFailWithError error: PNError!){
        println("Subscribe Error: \(error)")
        self.pubStatus.text = "Subscription Error"
    }
}