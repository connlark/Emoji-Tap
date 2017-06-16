//
//  AppDelegate.swift
//  Pop a Lock
//
//  Created by Connor Larkin on 6/22/16.
//  Copyright © 2016 Connor Larkin. All rights reserved.
//

import UIKit
import Firebase
import CoreMotion

internal var motionManager: CMMotionManager!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
       
        // Use Firebase library to configure APIs
        FIRApp.configure()
        
        return true
    }
    

    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        print("SHORTCUT")
        // Handle quick actions
        completionHandler(handleQuickAction(shortcutItem))
        
    }
    
    
    func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        var quickActionHandled = false
        let type = shortcutItem.type
       
        if type.containsString("reset") {
            highScore = 0
            NSUserDefaults.standardUserDefaults().setInteger( highScore, forKey:"HighestScore")
            quickActionHandled = true
            highScoreLabel.updateLabel("High Score: 0")
        }
        else if(type.containsString("fill")){
            fillHerUP = true
            
            quickActionHandled = true
        }
        
        return quickActionHandled
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

