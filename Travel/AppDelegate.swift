//
//  AppDelegate.swift
//  Jouz
//
//  Created by ANKER on 2017/12/8.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit
import Bugly

let log = LogManager.sharedInstance.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        LogManager.sharedInstance.setupLog() // 设置Log
        setupBugly() // 设置Bugly
        setupBase() // 设置一些基础属性
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }
    
    // MARK: - Private
    
    private func setupBugly() {
        Bugly.start(withAppId: "c84cb6d165")
    }
    
    private func setupBase() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance()
    }

}

