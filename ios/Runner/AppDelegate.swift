import UIKit
import Flutter
import Firebase
import FirebaseMessaging

import flutter_callkit_incoming
import AVFAudio
import CallKit
import PushKit

@main

@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        getPushNotificationAuthentication()
        
        GeneratedPluginRegistrant.register(with: self)
        
        //Setup VOIP
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
        
        if let notification = launchOptions?[.remoteNotification] as? [String: Any] {
            // App was launched from notification
            handleNotification(notification)
        }
        
        if let remoteNotification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            // Handle the VoIP notification to show the call screen
            let flutterChannel = FlutterMethodChannel(name: "com.vTeachTeacher.voip_call", binaryMessenger: (UIApplication.shared.delegate as! FlutterAppDelegate).window.rootViewController as! FlutterBinaryMessenger)
            flutterChannel.invokeMethod("handleIncomingCall", arguments: nil)
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    // Call back from Recent history
    override func application(_ application: UIApplication,
                              continue userActivity: NSUserActivity,
                              restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard let handleObj = userActivity.handle else {
            return false
        }
        
        guard let isVideo = userActivity.isVideo else {
            return false
        }
        
        let objData = handleObj.getDecryptHandle()
        let nameCaller = objData["nameCaller"] as? String ?? ""
        let handle = objData["handle"] as? String ?? ""
        let data = flutter_callkit_incoming.Data(id: UUID().uuidString, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
        //set more data...
        //data.nameCaller = nameCaller
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.startCall(data, fromPushKit: true)
        
        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Print the token or send it to your server
        print("FCM token: \(String(describing: fcmToken))")
    }
}

//MARK: - Notification setup

extension AppDelegate{
    func getPushNotificationAuthentication()
    {
        let noti_center = UNUserNotificationCenter.current()
        noti_center.delegate = self
        noti_center.requestAuthorization(options: [.alert,.badge, .sound, .carPlay]) { (isGranted, error) in
            debugPrint("\nRequest Authorisation >>>>>\(isGranted ? "Granted" : "Not Granted") Error >>>>>>\(String(describing: error))")
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        getPushNotificationAuthentication()
    }
    
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
#if targetEnvironment(simulator)
        print("i am not available in simulator \(error)")
#else
        print("i am not available in device \(error)")
#endif
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Foundation.Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs Device Token: \(token)")
        let controller = self.window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "com.vTeachTeacher.device_token", binaryMessenger: controller.binaryMessenger)
        methodChannel.invokeMethod("updateDeviceToken", arguments: token)
        
        print("APNs Device Token: \(token)")
        Messaging.messaging().apnsToken = deviceToken
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.userInfo)
        let userInfo = notification.request.content.userInfo

        let defaultChanel = "com.vTeachTeacher.vTeachTeacher_default_notifications"
        guard let rootViewController = window?.rootViewController as? FlutterViewController else {
            print("Root view controller is not a FlutterViewController")
            return
        }
        
        
        let defaultChannel = FlutterMethodChannel(
            name: defaultChanel,
            binaryMessenger: rootViewController.binaryMessenger
        )
        
        let defaultMethodName = "onNotificationCome"
        
        guard
            let extraPayload = userInfo["extra_data"] as? [String: Any]
        else { return }
                
        defaultChannel.invokeMethod(defaultMethodName, arguments: [
            "extraPayLoad": extraPayload,
            "notification_type": userInfo["notification_type"] as? String ?? ""
        ])

        completionHandler([.alert, .sound, .badge])
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        let notificationData = userInfo
        
        let defaultChanel = "com.vTeachTeacher.vTeachTeacher_default_notifications_Comes"
        
        guard let rootViewController = window?.rootViewController as? FlutterViewController else {
            print("Root view controller is not a FlutterViewController")
            return
        }
        
        
        let defaultChannel = FlutterMethodChannel(
            name: defaultChanel,
            binaryMessenger: rootViewController.binaryMessenger
        )
        
        let defaultMethodName = "onNotificationCome"
        
        guard
            let extraPayload = notificationData["extra_data"] as? [String: Any]
        else { return }
                
        defaultChannel.invokeMethod(defaultMethodName, arguments: [
            "extraPayLoad": extraPayload,
            "notification_type": notificationData["notification_type"] as? String ?? ""
        ])

        
        completionHandler(.newData)
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         didReceive response: UNNotificationResponse,
                                         withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification tapped") // Debug log
        let userInfo = response.notification.request.content.userInfo
        print("Notification userInfo: \(userInfo)") // Debug log
        handleNotification(userInfo as? [String: Any] ?? [:],isTapOnNotification: true)
        completionHandler()
    }
    
    private func handleNotification(_ notification: [String: Any],isTapOnNotification : Bool = false) {
        if isTapOnNotification{
            let channel = FlutterMethodChannel(
                name: "com.vTeachTeacher.vTeachTeacher_notifications",
                binaryMessenger: window.rootViewController as! FlutterBinaryMessenger
            )
            
            
            guard let extraPayload = notification["extra_data"] as? [String: Any],
                  let notificationType = notification["notification_type"] as? String else { return }
            
            
            print(extraPayload)
            
            channel.invokeMethod("onNotificationTap", arguments: [
                "extraPayLoad": extraPayload,
                "notification_type": notificationType
            ])
        }else{
            let channel = FlutterMethodChannel(
                name: "com.vTeachTeacher.vTeachTeacher_notifications_comes",
                binaryMessenger: window.rootViewController as! FlutterBinaryMessenger
            )
            
            
            guard let extraPayload = notification["extra_data"] as? [String: Any],
                  let notificationType = notification["notification_type"] as? String else { return }
            
            
            print(extraPayload)
            
            channel.invokeMethod("onNotificationCome", arguments: [
                "extraPayLoad": extraPayload,
                "notification_type": notificationType
            ])
        }
    }
}

// MARK: - VOIP Setup

extension AppDelegate : PKPushRegistryDelegate , CallkitIncomingAppDelegate{
    func onAccept(_ call: flutter_callkit_incoming.Call, _ action: CXAnswerCallAction) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.startCall(call.data, fromPushKit: true)
        action.fulfill()
    }
    
    func onDecline(_ call: flutter_callkit_incoming.Call, _ action: CXEndCallAction) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endCall(call.data)
        action.fulfill()
    }
    
    func onEnd(_ call: flutter_callkit_incoming.Call, _ action: CXEndCallAction) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endCall(call.data)
        action.fulfill()
    }
    
    func onTimeOut(_ call: flutter_callkit_incoming.Call) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endCall(call.data)
    }
    
    func didActivateAudioSession(_ audioSession: AVAudioSession) {
        
    }
    
    func didDeactivateAudioSession(_ audioSession: AVAudioSession) {
        
    }
    
    
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let deviceToken = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        print("VOIP DeviceToken \(deviceToken)")
        //Save deviceToken to your server
        let controller = self.window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "com.vTeachTeacher.voip_token", binaryMessenger: controller.binaryMessenger)
        methodChannel.invokeMethod("updateVoipToken", arguments: deviceToken)
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }
    
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("didInvalidatePushTokenFor")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }
    
    // Handle incoming pushes
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        guard type == .voIP else { return }
        
        let payloadDict = payload.dictionaryPayload
        print("Received VoIP push payload: \(payloadDict)")
        
        guard let extraData = payloadDict["extra_data"] as? [String: Any] else {
            print("No extra_data found in payload")
            return
        }
        
        let id = UUID().uuidString
        let nameCaller = extraData["full_name"] as? String ?? "Unknown"
        let handle = extraData["handle"] as? String ?? ""
        let isVideo = extraData["isVideo"] as? Bool ?? false
        
        let data = flutter_callkit_incoming.Data(id: id, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
        print("Before data.extra")
        // Convert [String: Any] to NSDictionary
        data.extra = NSDictionary(dictionary: extraData)
        print("After data.extra")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
        
        completion()
    }
}
