//
//  AppDelegate.swift
//  EasePeso
//
//  Created by apple on 2024/3/26.
//

import UIKit
import AppTrackingTransparency
import UserNotifications

import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SPFirstLaunchViewController()
        window?.makeKeyAndVisible()
        
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(registRemote), name: NSNotification.Name("sp_remoteNoti"), object: nil)
        
//        #if DEBUG
//        if NSClassFromString("Lookin") == nil {
//            dlopen("/Applications/Lookin.app/Contents/Resources/LookinServerFramework/LookinServer.framework/LookinServer", 0x2)
//        }
//        #endif
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let str = deviceToken.map { u8 in
            return String(format: "%02X", u8)
        }.joined()
        SPNetRequest
            .spRequestHandyData(SPZeroModel.self, url: "/classroom_asked", para: ["forsuiciding": str])
            .subscribe(onNext: { bigModel in
                SPPrint("bigModel == \(bigModel)")
            })
            .disposed(by: rx.disposeBag)
    }
    
    @objc func registRemote() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { finish, err in
            if finish {
                
            }
        }
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 17.4.1, *) {
            ATTrackingManager.requestTrackingAuthorization { sta in
                SPPrint("requestTrackingAuthorization sta == \(sta)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        SPPrint("tuisong == \(userInfo)")
//        guard let info = userInfo["aps"] as? [String: Any],
//              let notiIpo = info["alert"] as? [String: Any],
//              let jumpStr = notiIpo["ipo"] as? String else { return }
        
        guard let info = userInfo["params"] as? [String: Any],
              let jumpStr = info["smt"] as? String else { return }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(3)) {
            if let vc = SPKit.window?.rootViewController {
                judge(jumpStr, from: vc)
            }
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

