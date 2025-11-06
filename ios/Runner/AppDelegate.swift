import Flutter
import UIKit
//import notifyvisitors
import AdSupport
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if #available(iOS 14, *) {
             print("Initial ATT Status: \(ATTrackingManager.trackingAuthorizationStatus.rawValue)")
         }
      
      
      self.nvRequestTrackingPermissionIfNeeded { idfaStr in
          if let idfa = idfaStr {
                 print("User's IDFA: \(idfa)")
             } else {
                 print("IDFA not available (permission denied or not requested)")
             }
      }
      
      NotifyvisitorsPlugin.nvInitialize()
      UNUserNotificationCenter.current().delegate = self
      NotifyvisitorsPlugin.registerPush(withDelegate: self, app: application, launchOptions: launchOptions)
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func nvRequestTrackingPermissionIfNeeded(completion: @escaping (String?) -> Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        completion(self.nvFlutterFetchIDFA())
                    } else {
                        completion(nil)
                    }
                }
            }
        } else {
            // iOS 12 and 13
            completion(nvFlutterFetchIDFA())
        }
    }
    
    func nvFlutterFetchIDFA() -> String? {
        let manager = ASIdentifierManager.shared()
        let idfa = manager.advertisingIdentifier
        if manager.isAdvertisingTrackingEnabled && idfa.uuidString != "00000000-0000-0000-0000-000000000000" {
            return idfa.uuidString
        }
        return nil
    }
    
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        NotifyvisitorsPlugin.applicationDidEnterBackground(application)
    }
    override func applicationWillEnterForeground(_ application: UIApplication) {
        NotifyvisitorsPlugin.applicationWillEnterForeground(application)
    }
    override func applicationDidBecomeActive(_ application: UIApplication) {
        NotifyvisitorsPlugin.applicationDidBecomeActive(application)
    }
    override func applicationWillTerminate(_ application: UIApplication) {
        NotifyvisitorsPlugin.applicationWillTerminate()
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NotifyvisitorsPlugin.openUrl(app, open: url)
        return super.application(app, open: url)
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotifyvisitorsPlugin.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NotifyvisitorsPlugin.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NotifyvisitorsPlugin.willPresent(notification, withCompletionHandler: completionHandler)
    }
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        NotifyvisitorsPlugin.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NotifyvisitorsPlugin.didReceive(response)
    }
}
