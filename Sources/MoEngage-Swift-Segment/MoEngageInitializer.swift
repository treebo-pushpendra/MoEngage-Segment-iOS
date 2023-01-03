//
//  File.swift
//  
//
//  Created by Deepa on 29/12/22.
//

import Foundation
import MoEngageSDK

@objc
public class MoEngageInitializer: NSObject {
    
    public static let shared = MoEngageInitializer()
    public var config: MoEngageSDKConfig?
    
    private let segmentVersion = "7.1.0"
    private override init() {
        
    }
    
    public func initializeDefaultInstance(sdkConfig: MoEngageSDKConfig) {
        updateSDKConfig(sdkConfig: sdkConfig)
#if DEBUG
        MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig)
#endif
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }
    
    public func initializeInstance(sdkConfig: MoEngageSDKConfig) {
        updateSDKConfig(sdkConfig: sdkConfig)
#if DEBUG
        MoEngage.sharedInstance.initializeTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeiveInstance(sdkConfig)
#endif
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }
    
    func updateSDKConfig(sdkConfig: MoEngageSDKConfig) {
        sdkConfig.setPartnerIntegrationType(integrationType: MoEngagePartnerIntegrationType.segment)
        config = sdkConfig
    }
    
    func trackPluginTypeAndVersion(sdkConfig: MoEngageSDKConfig) {
        let integrationInfo = MoEngageIntegrationInfo(pluginType: "segment", version: segmentVersion)
        MoEngageCoreIntegrator.sharedInstance.addIntergrationInfo(info: integrationInfo, appId: sdkConfig.moeAppID)
    }
}
