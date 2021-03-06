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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

