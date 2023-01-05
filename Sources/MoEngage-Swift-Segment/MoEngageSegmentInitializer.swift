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
    @objc public static let shared = MoEngageSegmentInitializer()
    
    public var analytics: Analytics!
    
    private override init() {

    }
    
    @objc public func initializeSegmentAnalytics(writeKey: String, flushAt: Int = 3, flushInterval: TimeInterval = 10) {
        guard analytics == nil else { return }
        let config = Configuration(writeKey: writeKey)
            // Automatically track Lifecycle events
            .trackApplicationLifecycleEvents(true)
            .flushAt(flushAt)
            .flushInterval(flushInterval)

        analytics = Analytics(configuration: config)
        analytics.add(plugin: MoEngageDestination())
    }
    
}
