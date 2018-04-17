//
//  AppDelegate.swift
//  Madison Bar Specials & Nightlife
//
//  Created by Vivek Malani on 29/11/17.
//  Copyright © 2017 VivekMalani. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import UserNotifications
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable=true
        GMSServices.provideAPIKey("AIzaSyCsScs8FR_AGMvJSqjNcbj5oeWVRgNNFwc")
        GMSPlacesClient.provideAPIKey("AIzaSyCsScs8FR_AGMvJSqjNcbj5oeWVRgNNFwc")
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = AppThemeColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().shadowImage = UIImage()
        UISearchBar.appearance().barStyle = .black
        
        FirebaseApp.configure()
        NotificationCenter.default.addObserver(self,selector: #selector(tokenRefreshNotification(_:)),name: NSNotification.Name.InstanceIDTokenRefresh,object: nil)
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            //Messaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
//        if Default.value(forKey: "CheckStudent") != nil
//        {
//            let Stry = UIStoryboard(name: "Main", bundle: nil)
//            let ViewController = Stry.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
//            window?.rootViewController = ViewController
//            window?.makeKeyAndVisible()
//        }
        return true
    }

    @objc func tokenRefreshNotification(_ notification: Foundation.Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            Token = refreshedToken
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
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

