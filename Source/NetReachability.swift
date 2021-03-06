//
//  NetReachability.swift
//  
//
//  Created by 刘凡 on 15/4/6.
//
//

import Foundation
import SystemConfiguration

public enum NetworkStatus: Printable {
    case NotReachable, ReachableViaWiFi, ReachableViaWWAN
    
    public var description: String {
        switch self {
        case .ReachableViaWWAN:
            return "2G/3G/4G"
        case .ReachableViaWiFi:
            return "WiFi"
        case .NotReachable:
            return "No Connection"
        }
    }
}

public class NetReachability {
    
    public class func reachabilityWithHostName(hostName: String) -> NetworkStatus {
        let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault , hostName.cStringUsingEncoding(NSUTF8StringEncoding)!).takeRetainedValue()
        
        var flags: SCNetworkReachabilityFlags = 0
        
        let result = SCNetworkReachabilityGetFlags(reachability, &flags)
        
        if (flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsReachable) == 0) {
            return NetworkStatus.NotReachable;
        }
        
        var returnValue = NetworkStatus.NotReachable;
        
        if flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsConnectionRequired) == 0 {
            returnValue = NetworkStatus.ReachableViaWiFi
        }
        
        if flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsConnectionOnDemand) != 0 ||
            flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0 {
            
                if flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsInterventionRequired) == 0 {
                    returnValue = NetworkStatus.ReachableViaWiFi
                }
        }
        
        if (flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsIsWWAN)) == SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsIsWWAN) {
            returnValue = NetworkStatus.ReachableViaWWAN
        }
        
        return returnValue;
    }
}
