//
//  AppDelegate.swift
//  SwiftExample
//
//  Created by Martin Barreto on 3/10/15.
//  Copyright (c) 2014-2015 Xmartlabs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Declare custom rows
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeRate] =  "XLFormRatingCell"
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeFloatLabeledTextField] = FloatLabeledTextFieldCell.self
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeWeekDays] = "XLFormWeekDaysCell"
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeSegmentedInline] = InlineSegmentedCell.self
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeSegmentedControl] = InlineSegmentedControl.self
        XLFormViewController.inlineRowDescriptorTypesForRowDescriptorTypes()[XLFormRowDescriptorTypeSegmentedInline] = XLFormRowDescriptorTypeSegmentedControl
        
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        // Override point for customization after application launch.
        self.window!.backgroundColor = .white
    
        // load the initial form form Storybiard
        let storyboard = UIStoryboard.init(name:"iPhoneStoryboard", bundle:nil)
        self.window!.rootViewController = storyboard.instantiateInitialViewController()
        self.window!.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

