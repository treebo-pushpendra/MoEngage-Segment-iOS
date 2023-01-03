import Segment
import MoEngageSDK
import UIKit

@objc
public class MoEngageDestination: UIResponder, DestinationPlugin {
    public let timeline = Timeline()
    public let type = PluginType.destination
    public let key = "MoEngage"
    
    public var analytics: Analytics?
    private var sdkConfig: MoEngageSDKConfig?
    private var moengageSettings: MoEngageSettings?
    private let segmentAnonymousIDAttribute = "USER_ATTRIBUTE_SEGMENT_ID"
    
    public override init() {
    }
    
    public func update(settings: Settings, type: UpdateType) {
        guard type == .initial else { return }

        guard let tempSettings: MoEngageSettings = settings.integrationSettings(forPlugin: self) else { return }
        moengageSettings = tempSettings
        
        guard let appID = moengageSettings?.apiKey, let moeAppID = MoEngageInitializer.shared.config?.moeAppID else {
            return
        }
        if appID != moeAppID {
            return
        }
                
        MoEngageCoreIntegrator.sharedInstance.enableSDKForSegment(instanceID: appID)
        
        DispatchQueue.main.async {
            if let segmentAnonymousID = self.analytics?.anonymousId {
                MoEngageSDKAnalytics.sharedInstance.setUserAttribute(segmentAnonymousID, withAttributeName: self.segmentAnonymousIDAttribute, forAppID: appID)
            }
        }
        
        if UNUserNotificationCenter.current().delegate == nil {
            UNUserNotificationCenter.current().delegate = self
        }
    }
    
    public func identify(event: IdentifyEvent) -> IdentifyEvent? {
        if let userId = event.userId, !userId.isEmpty {
            MoEngageSDKAnalytics.sharedInstance.setUniqueID(userId, forAppID: moengageSettings?.apiKey)
        }
        
        if let traits = event.traits?.dictionaryValue {
            if let birthday = traits["birthday"] as? String {
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                if let formattedBirthday = dateformatter.date(from: birthday) {
                    MoEngageSDKAnalytics.sharedInstance.setDateOfBirth(formattedBirthday, forAppID: moengageSettings?.apiKey)
                }
            }
            
            if let name = traits["name"] as? String {
                MoEngageSDKAnalytics.sharedInstance.setName(name, forAppID: moengageSettings?.apiKey)
            }
            if let birthday = traits["isoBirthday"] as? String {
                MoEngageSDKAnalytics.sharedInstance.setDateOfBirthInISO(birthday, forAppID: moengageSettings?.apiKey)
                
            }
            
            if let email = traits["email"] as? String {
                MoEngageSDKAnalytics.sharedInstance.setEmailID(email, forAppID: moengageSettings?.apiKey)
            }

            if let firstName = traits["firstName"] as? String {
                MoEngageSDKAnalytics.sharedInstance.setFirstName(firstName, forAppID: moengageSettings?.apiKey)
            }

            if let lastName = traits["lastName"] as? String {
                MoEngageSDKAnalytics.sharedInstance.setLastName(lastName, forAppID: moengageSettings?.apiKey)
            }
            
            if let gender = traits["gender"] as? String {
                if gender.lowercased() == "m" || gender.lowercased() == "male" {
                    MoEngageSDKAnalytics.sharedInstance.setGender(.male, forAppID: moengageSettings?.apiKey)
                }
                else if gender.lowercased() == "f" || gender.lowercased() == "female" {
                    MoEngageSDKAnalytics.sharedInstance.setGender(.female, forAppID: moengageSettings?.apiKey)
                }
                else {
                    MoEngageSDKAnalytics.sharedInstance.setGender(.others, forAppID: moengageSettings?.apiKey)
                }
            }
                        
            if let phone = traits["phone"] as? String {
                MoEngageSDKAnalytics.sharedInstance.setMobileNumber(phone, forAppID: moengageSettings?.apiKey)
            }
       
            if let isoDate = traits["isoDate"] as? [String: Any] {
                if let date = isoDate["date"] as? Date, let attributeName = isoDate["attributeName"] as? String {
                    MoEngageSDKAnalytics.sharedInstance.setUserAttributeDate(date, withAttributeName: attributeName, forAppID: moengageSettings?.apiKey)
                }
            }
            
            if let location = traits["location"] as? [String: Any] {
                if let latitute = location["latitude"] as? Double, let longitude = location["longitude"] as? Double {
                    MoEngageSDKAnalytics.sharedInstance.setLocation(MoEngageGeoLocation.init(withLatitude: latitute, andLongitude: longitude))
                }
            }
            
            let moengageTraits = ["userName", "phone", "gender", "lastName", "firstName", "email", "isoBirthday", "isoDate", "location"]
            
            for trait in traits where !moengageTraits.contains(trait.key) {
                switch trait.value {
                case let val as String:
                    MoEngageSDKAnalytics.sharedInstance.setUserAttribute(val, withAttributeName: trait.key, forAppID: moengageSettings?.apiKey)
                case let val as Date:
                    MoEngageSDKAnalytics.sharedInstance.setUserAttributeDate(val, withAttributeName: trait.key, forAppID: moengageSettings?.apiKey)
                case let val as Bool:
                    MoEngageSDKAnalytics.sharedInstance.setUserAttribute(val, withAttributeName: trait.key, forAppID: moengageSettings?.apiKey)
                case let val as Int:
                    MoEngageSDKAnalytics.sharedInstance.setUserAttribute(val, withAttributeName: trait.key, forAppID: moengageSettings?.apiKey)
                case let val as Double:
                    MoEngageSDKAnalytics.sharedInstance.setUserAttribute(val, withAttributeName: trait.key, forAppID: moengageSettings?.apiKey)
                default:
                    MoEngageSDKAnalytics.sharedInstance.setUserAttribute(trait.value, withAttributeName: trait.key, forAppID: moengageSettings?.apiKey)
                }
            }
        }

        return event
    }

    public func track(event: TrackEvent) -> TrackEvent? {
        if var generalAttributeDict = event.properties?.dictionaryValue {
            var dateAttributeDict: [AnyHashable : Any] = [:]
            
            for key in generalAttributeDict.keys {
                let val = generalAttributeDict[key]
                if val == nil || (val as? NSNull) == NSNull() {
                    generalAttributeDict.removeValue(forKey: key)
                    continue
                } else if val is String {
                    let converted_date = date(fromISOdateStr: val as? String)
                    if let converted_date {
                        dateAttributeDict[key] = converted_date
                        generalAttributeDict.removeValue(forKey: key)
                    }
                }
                
            }
            let moe_properties = MoEngageProperties(withAttributes: generalAttributeDict)
            for key in dateAttributeDict.keys {
                guard let key = key as? String else {
                    continue
                }
                if let dateVal = dateAttributeDict[key] as? Date {
                    moe_properties.addDateAttribute(dateVal, withName: key)
                }
            }
            MoEngageSDKAnalytics.sharedInstance.trackEvent(event.event, withProperties: moe_properties, forAppID: moengageSettings?.apiKey)
        }

        return event
    }
    

    func date(fromISOdateStr isoDateStr: String?) -> Date? {
        var dateFormatter: DateFormatter?
        if let isoDateStr {
            dateFormatter = DateFormatter()
            dateFormatter!.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter!.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
            dateFormatter!.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
            return dateFormatter?.date(from: isoDateStr)
        }
        return nil
    }
    
    public func alias(event: AliasEvent) -> AliasEvent? {
        let appId = moengageSettings?.apiKey
        if let userId = event.userId {
            MoEngageSDKAnalytics.sharedInstance.setAlias(userId, forAppID: appId)
        }
        return event
    }
    
    public func flush() {
        let appID = moengageSettings?.apiKey
        MoEngageSDKAnalytics.sharedInstance.flush(forAppID: appID)
    }
    
    public func reset() {
        let appID = moengageSettings?.apiKey
        MoEngageSDKAnalytics.sharedInstance.resetUser(forAppID: appID)
    }
}

// MARK: - Application Life cycle methods
extension MoEngageDestination: iOSLifecycle {

    public func application(_ application: UIApplication?, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        print("Test")
    }
}

// MARK: - Push Notification methods

extension MoEngageDestination: RemoteNotifications {
    public func registeredForRemoteNotifications(deviceToken: Data) {
        MoEngageSDKMessaging.sharedInstance.setPushToken(deviceToken)
    }
    
    public func failedToRegisterForRemoteNotification(error: Error?) {
        MoEngageSDKMessaging.sharedInstance.didFailToRegisterForPush()
    }
    
    public func receivedRemoteNotification(userInfo: [AnyHashable : Any]) {
        MoEngageSDKMessaging.sharedInstance.didReceieveNotification(withInfo: userInfo)
    }
}

// MARK: - User Notification Center delegate methods
extension MoEngageDestination: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert , .sound])
    }
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

public struct MoEngageSettings: Codable {
    public var apiKey: String
}
