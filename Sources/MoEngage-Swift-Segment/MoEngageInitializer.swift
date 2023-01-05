//
//  File.swift
//  
//
//  Created by Deepa on 29/12/22.
//

import Foundation
import MoEngageSDK

/// This class is used for initializing the MoEngageSDK
@objc
public class MoEngageInitializer: NSObject {
    
    @objc public static let shared = MoEngageInitializer()
    @objc public var config: MoEngageSDKConfig?
    
    private let segmentVersion = "8.0.0"
    private override init() {
        
    }
    
    /// Method to initialize the default instance of MoEngageSDK
    /// - Parameter sdkConfig: MoEngageSDKConfig
    @objc public func initializeDefaultInstance(sdkConfig: MoEngageSDKConfig) {
        updateSDKConfig(sdkConfig: sdkConfig)
#if DEBUG
        MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig)
#endif
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }
    
    /// Method to initialize the other instance of MoEngageSDK
    /// - Parameter sdkConfig: MoEngageSDKConfig
    @objc public func initializeInstance(sdkConfig: MoEngageSDKConfig) {
        updateSDKConfig(sdkConfig: sdkConfig)
#if DEBUG
        MoEngage.sharedInstance.initializeTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeLiveInstance(sdkConfig)
#endif
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }
    
    @objc func updateSDKConfig(sdkConfig: MoEngageSDKConfig) {
        sdkConfig.setPartnerIntegrationType(integrationType: MoEngagePartnerIntegrationType.segment)
        config = sdkConfig
    }
    
    @objc func trackPluginTypeAndVersion(sdkConfig: MoEngageSDKConfig) {
        let integrationInfo = MoEngageIntegrationInfo(pluginType: "segment", version: segmentVersion)
        MoEngageCoreIntegrator.sharedInstance.addIntergrationInfo(info: integrationInfo, appId: sdkConfig.moeAppID)
    }
}
