//
//  PusherManager.swift
//  PusherIssues
//
//  Created by Rudy Suharyadi on 17/01/19.
//  Copyright © 2019 Rudy Suharyadi. All rights reserved.
//

import UIKit
import PusherSwift

class PusherManager: NSObject, PusherDelegate {

    public static let shared = PusherManager()
    
    let secret = ""
    let cluster = ""
    let key = ""
    var pusher:Pusher?
    var channel:PusherChannel?
    
    override private init() {
        super.init()
        
        let authMethod = OCAuthMethod.init(secret: secret)
        let host = OCPusherHost.init(cluster: cluster)
        let options = PusherClientOptions.init(ocAuthMethod: authMethod,
                                               attemptToReturnJSONObject: true,
                                               autoReconnect: true,
                                               ocHost: host,
                                               port: nil,
                                               encrypted: true,
                                               activityTimeout: 60)
        
        self.pusher = Pusher.init(withAppKey: key, options: options)
        self.pusher?.connect()
        self.pusher?.connection.delegate = self
        
        self.channel = self.pusher?.subscribeToPresenceChannel(channelName: String.init(format: "moka-%li-%li", 94, 73))
        self.channel?.bind(eventName: "ingredients", callback: { (data) in
            print("Ingredient Pusher Event")
            DispatchQueue.global().async {
                let operationQueue = OperationQueue()
                let blockOperation = BlockOperation.init(block: {
                    //do heavy task here, just simulate with sleep for 5 sec.
                    sleep(5)
                })
                operationQueue.addOperation(blockOperation)
                operationQueue.waitUntilAllOperationsAreFinished()
                print("done")
            }
        })
    }
    
}
