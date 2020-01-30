//
//  AppDelegate.swift
//  Straat
//
//  Created by Global Array on 29/01/2019.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import FirebaseMessaging

protocol FirebaseDelegate {
    func newMessageReceived(conversationId: String?)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    let uds = UserDefaults.standard
    var firebaseDelegate: FirebaseDelegate!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyDZhDD8SHZ8Sj3HIHvSttz3-Ow6gNRCQdM")
        GMSPlacesClient.provideAPIKey("AIzaSyDZhDD8SHZ8Sj3HIHvSttz3-Ow6gNRCQdM")

//		GMSServices.provideAPIKey("AIzaSyCWetIVXBhjoLGnHY5LcpuvU_LWvMO-lUI")
//		GMSPlacesClient.provideAPIKey("AIzaSyCWetIVXBhjoLGnHY5LcpuvU_LWvMO-lUI")

        let userModel = UserModel()
        let id = userModel.getDataFromUSD(key: user_id)
        
        if id != "" {
            print("user_id_res: true")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let mv = sb.instantiateViewController(withIdentifier: "SWRevealViewControllerID")
            window?.rootViewController = mv
        }
        else {
            print("user_id_res: false")
            let sb = UIStoryboard(name: "Initial", bundle: nil)
            let checkCode = sb.instantiateViewController(withIdentifier: "SecondScreenID")
            window?.rootViewController = checkCode
        }
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self as! MessagingDelegate
        
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self as! UNUserNotificationCenterDelegate
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//        application.registerForRemoteNotifications()

		if #available(iOS 10.0, *) {
			// For iOS 10 display notification (sent via APNS)
			UNUserNotificationCenter.current().delegate = self as! UNUserNotificationCenterDelegate

			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//			UNUserNotificationCenter.current().requestAuthorization(
//				options: authOptions,
//				completionHandler: {_, _ in })
			
			UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
				print("granted \(granted)")
				print("error \(error)")
			}
			
		} else {
			let settings: UIUserNotificationSettings =
				UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
			application.registerUserNotificationSettings(settings)
		}
		application.registerForRemoteNotifications()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.notifyForNewMessage(userInfo: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID1: \(messageID)")
        }

        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID2: \(messageID)")
            let conversationId = userInfo["_conversation"] as! String?
            // firebaseDelegate.newMessageReceived(conversationId: conversationId)
            
            
            let state = application.applicationState
            switch state {
                
            case .inactive:
                print("Inactive")
                
            case .background:
                let customID = userInfo["customPayloadId"] as? String
                print("Message ID: \(customID)")
                UNUserNotificationCenter.current()
                    .getDeliveredNotifications { notifications in
                        print("NOTIFICATIONS_: \(notifications)")
                        let matching = notifications.last(where: { notify in
                            let existingUserInfo = notify.request.content.userInfo
                            let id = existingUserInfo["customPayloadId"] as? String
                            return id == customID
                        })
                        
                        if let matchExists = matching {
                            if notifications.count > 1 {
                                UNUserNotificationCenter.current().removeDeliveredNotifications(
                                    withIdentifiers: [matchExists.request.identifier]
                                )
                            }
                            print("NOTIFICATIONS_ Count: \(notifications.count)")
                            
                        }
                        
                }
                
            case .active:
                print("Active")
                self.notifyForNewMessage(userInfo: userInfo)
            }
        }
        
        // Print full message.
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }


}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID3: \(messageID)")
            let conversationId = userInfo["_conversation"] as! String?
//            firebaseDelegate.newMessageReceived(conversationId: conversationId)
            let customID = userInfo["customPayloadId"] as? String
            print("Message ID: \(customID)")
//            UNUserNotificationCenter.current()
//                .getDeliveredNotifications { notifications in
//                    let matching = notifications.first(where: { notify in
//                        let existingUserInfo = notify.request.content.userInfo
//                        let id = existingUserInfo["customPayloadId"] as? String
//                        return id == customID
//                    })
//
//                    if let matchExists = matching {
//                        UNUserNotificationCenter.current().removeDeliveredNotifications(
//                            withIdentifiers: [matchExists.request.identifier]
//                        )
//                    }
//
//            }
            self.notifyForNewMessage(userInfo: userInfo)
        }
        
        // Print full message.
        print(userInfo)
        print(userInfo["_conversation"])
        
        // Change this to your preferred presentation option
         completionHandler([.alert, .sound])
    }
    
}
// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        uds.set(fcmToken, forKey: firebase_token)
        print(fcmToken)
        let user = UserModel()
        let authService = AuthService()
        if let userId = user.id, let email = user.email {
            authService.addUpdateFirebaseToken(userId: userId, email: email, firebaseToken: fcmToken) { success in
                
            }
        }
        
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}


extension AppDelegate {
    // private functions
    private func notifyForNewMessage (userInfo: [AnyHashable : Any]?) {
        let name = Notification.Name(rawValue: fcm_new_message)
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
    private func goToReportsPage () {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let reportsC = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
//        if reportsC != nil {
//            reportsC.view.frame = (self.window!.frame)
//            self.window!.addSubview(reportsC.view)
//            self.window!.bringSubviewToFront(reportsC.view)
//        }
    
    }
	
//	private func notificationPermission() -> Void {
//		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
//			print("granted \(granted)")
//
//		}
//	}
}
