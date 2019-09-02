//
//  ReachabilityController.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Reachability

class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    var reachabilityStatus: Reachability.Connection = .none
    let reachability = Reachability()!
    var listeners: [NetworkStatusListener] = []
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .none
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            debugPrint("Network became unreachable")
            let vc = UIApplication.shared.getWindow()?.rootViewController
            vc?.reachabilityView(hasConection: false)
            
        case .wifi, .cellular:
            debugPrint("Network reachable through WiFi")
            let vc = UIApplication.shared.getWindow()?.rootViewController
            vc?.reachabilityView(hasConection: true)
        }
        
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.connection)
        }
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ReachabilityManager.reachabilityChanged(notification:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    func addListener(listener: NetworkStatusListener){
        listeners.append(listener)
    }
    
    func removeListener(listener: NetworkStatusListener){
        listeners = listeners.filter{ $0 !== listener}
    }
}
