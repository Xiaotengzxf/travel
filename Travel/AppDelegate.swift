//
//  AppDelegate.swift
//  Jouz
//
//  Created by ANKER on 2017/12/8.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit
import Bugly
import IQKeyboardManagerSwift

let log = LogManager.sharedInstance.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        LogManager.sharedInstance.setupLog() // 设置Log
        setupBugly() // 设置Bugly
        setupBase() // 设置一些基础属性
        setRootViewController()
        RPSDK.initialize(.online) // 阿里云
        IQKeyboardManager.shared.enable = true
        // 百度地图 clXMmMNzvsTeTdcEDCUrfvzltSQvex6Y
        // 环信
        let options = EMOptions(appkey: "1111181027222869#travel") // TODO: key
        options?.apnsCertName = "travel2019Dev" // TODO: APNS
        if options != nil {
            EMClient.shared().initializeSDK(with: options!)
        }
        
        EaseSDKHelper.share()?.hyphenateApplication(application, didFinishLaunchingWithOptions: launchOptions, appkey: "1111181027222869#travel", apnsCertName: "travel2019Dev", otherConfig: ["kSDKConfigEnableConsoleLogger": true])
        
        JUploadMassageManager.sharedInstance.testLog()
        
        // 微信支付
        WXApi.registerApp("wxaee2b9ceea16f729", enableMTA: false)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: {
                (resultDic) -> Void in
                //调起支付结果处理
                
            })
            return true;
        } else {
            return WXApi.handleOpen(url, delegate: WXApiManager.shared())
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: {
                (resultDic) -> Void in
                //调起支付结果处理
                //        9000  订单支付成功
                //        8000  正在处理中
                //        4000  订单支付失败
                //        6001  用户中途取消
                //        6002  网络连接出错
                if let result = resultDic as? [String : Any] {
                    let code = result["code"] as? Int ?? 0
                }
            })
            return true;
        } else {
           return WXApi.handleOpen(url, delegate: WXApiManager.shared())
        }
        
    }
    
    // MARK: - Private
    
    private func setupBugly() {
        Bugly.start(withAppId: "c84cb6d165")
    }
    
    private func setupBase() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setRootViewController() {
        if let phone = UserDefaults.standard.object(forKey: kPhone) as? String, phone.count > 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "JTabBarController") as? JTabBarController {
                window?.rootViewController = vc
            }
        }
    }

}

