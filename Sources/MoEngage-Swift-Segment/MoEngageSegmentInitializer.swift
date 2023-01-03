//
//  MoEngageSegmentInitializer.swift
//  
//
//  Created by Deepa on 02/01/23.
//

import Foundation
import Segment

@objc
public class MoEngageSegmentInitializer: NSObject {
    public static let shared = MoEngageSegmentInitializer()
    
    public var analytics: Analytics!
    
    private override init() {

    }
    
    public func initializeSegmentAnalytics(writeKey: String) {
        guard analytics == nil else { return }
        let config = Configuration(writeKey: writeKey)
            // Automatically track Lifecycle events
            .trackApplicationLifecycleEvents(true)
            .flushAt(3)
            .flushInterval(10)

        analytics = Analytics(configuration: config)
        analytics.add(plugin: MoEngageDestination())
    }
    
}
