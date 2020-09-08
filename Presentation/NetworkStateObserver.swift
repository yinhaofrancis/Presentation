//
//  NetworkStateObserver.swift
//  Presentation
//
//  Created by hao yin on 2020/9/7.
//  Copyright © 2020 hao yin. All rights reserved.
//

import Foundation
import SystemConfiguration
public enum NetworkState{
    case WiFi
    case Noreach
    case other
}
public class NetworkStateObserver{
    public var url:URL
    private var mirror:NetworkStateObserver!
    var reachability:SCNetworkReachability
    var change:(NetworkState)->Void
    public init?(url:URL, change:@escaping (NetworkState)->Void) {
        self.url = url
        self.change = change
        if let host = url.host,let rec = SCNetworkReachabilityCreateWithName(nil, host){
            self.reachability = rec
        }else{
            return nil
        }
        return
    }
    public var netState:NetworkState{
        var flag:SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
         SCNetworkReachabilityGetFlags(self.reachability, &flag)

        return NetworkStateObserver.netStateTransform(flag: flag)
    }
    static public func netStateTransform(flag:SCNetworkReachabilityFlags)->NetworkState{
        if flag.rawValue & SCNetworkReachabilityFlags.reachable.rawValue == 0{
           return .Noreach
        }
        var retV = NetworkState.Noreach
        if flag.rawValue & SCNetworkReachabilityFlags.connectionRequired.rawValue == 0{
           retV = .WiFi
        }
        if (flag.rawValue & SCNetworkReachabilityFlags.connectionOnDemand.rawValue != 0) ||
           (flag.rawValue & SCNetworkReachabilityFlags.connectionOnTraffic.rawValue != 0) {
           if flag.rawValue & SCNetworkReachabilityFlags.interventionRequired.rawValue == 0 {
               retV = .WiFi
           }
        }
        if (flag.rawValue & SCNetworkReachabilityFlags.isWWAN.rawValue) == SCNetworkReachabilityFlags.isWWAN.rawValue{
           retV = .other
        }
        return retV
    }
    public func startNotifer(){
        self.mirror = self
        var ctx = SCNetworkReachabilityContext(version: 0, info: &self.mirror, retain: nil, release: nil, copyDescription: nil)
        let b = SCNetworkReachabilitySetCallback(self.reachability, { (re, fl, info:UnsafeMutableRawPointer?) in
            let p = info?.assumingMemoryBound(to: NetworkStateObserver.self)
            let state = NetworkStateObserver.netStateTransform(flag: fl)
            let ob = p?.pointee
            ob?.change(state)
        }, &ctx)
        if(b){
            SCNetworkReachabilityScheduleWithRunLoop(self.reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
        }
    }
    public func stopNotifier() {
        SCNetworkReachabilityUnscheduleFromRunLoop(self.reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
}
