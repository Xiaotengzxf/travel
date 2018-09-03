//
//  Constant.swift
//  Jouz
//
//  Created by ANKER on 2017/12/25.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit

// MARK: - FONT

let t1 = ZFontManager.sharedInstance.getFont(font: .t1)
let t2 = ZFontManager.sharedInstance.getFont(font: .t2)
let t3 = ZFontManager.sharedInstance.getFont(font: .t3)
let t32 = ZFontManager.sharedInstance.getFont(font: .t3, bBold: true)
let t4 = ZFontManager.sharedInstance.getFont(font: .t4)
let t42 = ZFontManager.sharedInstance.getFont(font: .t4, bBold: true)
let t5 = ZFontManager.sharedInstance.getFont(font: .t5)
let t6 = ZFontManager.sharedInstance.getOtherFont(font: .t3)

// MARK: - Color

let c1 = ZColorManager.sharedInstance.getColor(color: .c1)
let c2 = ZColorManager.sharedInstance.getColor(color: .c2)
let c3 = ZColorManager.sharedInstance.getColor(color: .c3)
let c4 = ZColorManager.sharedInstance.getColor(color: .c4)
let c6 = ZColorManager.sharedInstance.getColor(color: .c6)
let c7 = ZColorManager.sharedInstance.getColor(color: .c7)
let c8 = ZColorManager.sharedInstance.getColor(color: .c8)
let c9 = ZColorManager.sharedInstance.getColor(color: .c9)
let c_button_normal_left = ZColorManager.sharedInstance.getColor(color: .c_button_normal_left)
let c_button_normal_right = ZColorManager.sharedInstance.getColor(color: .c_button_normal_right)
let c_button_press_left = ZColorManager.sharedInstance.getColor(color: .c_button_press_left)
let c_button_press_right = ZColorManager.sharedInstance.getColor(color: .c_button_press_right)
let c_button_shadow = ZColorManager.sharedInstance.getColor(color: .c_button_shadow)
let c_background_top = ZColorManager.sharedInstance.getColor(color: .c_background_top)
let c_background_bottom = ZColorManager.sharedInstance.getColor(color: .c_background_bottom)


//MARK: - Padding

let kPaddingLeft: CGFloat = 20
let kPaddingRight: CGFloat = 20
let kPaddingTop: CGFloat = 20
let kPaddingBottom: CGFloat = 20

let kMenuOptionHeight: CGFloat = 75
let kMenuOptionImageHeight: CGFloat = 24

// MARK: - Dimension

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let scale: CGFloat = fmin(1, screenWidth / 375)

// MARK: - Notification

let kBluetoothSettingsNotification = Notification.Name("BluetoothSettingsNotification")
let kMainNotification = Notification.Name("SCMainModelServiceNotification")
let kRenameNotification = Notification.Name("JRenameModelServiceNotification")
let kAlertSettingNotification = Notification.Name("SCAlertSettingModelServiceNotification")
let kRootViewNotification = Notification.Name("SCRootViewController")
let kHeatStickNotification = Notification.Name("JHeatStickNotification")
let kFlavourNotification = Notification.Name("JFlavourNotification")
let kMoreNotification = Notification.Name("JMoreNotification")
let kMultiSelectNotification = Notification.Name("MultiSelectNotification")
let kMultiSelectRemoteNotification = Notification.Name("MultiSelectRemoteNotification")
let kSelfCleaningNotification = Notification.Name("kSelfCleaningNotification")
let kHomeNotification = Notification.Name("kHomeNotification")
let kOTAUpdateNotification = Notification.Name("kOTAUpdateNotification")
let kJManualCurveViewController = Notification.Name("JManualCurveViewController")
let kJHomeViewController = Notification.Name("JHomeViewController")
let kJRenameViewController = Notification.Name("JRenameViewController")
let kJSideMenuModelServiceNotification = Notification.Name("JSideMenuModelService")

// MARK: - UserDefaults

let udCustomrLanguageCode = "udCustomrLanguageCode"
let otaKey = "OTA"
let kApplicationKey = "applicationKey"
let kPhone = "phone"

// MARK: - Other String

let kBlueToothScan = "blueToothScan"
let kScanFinished = "scanFinished"
let kOTAUpdateFinished = "OTAUpdateFinished"
let kSlave = "slave"
let kConnectFailThreeTime = "kConnectFailThreeTime"
let kMultiSelectConnected = "kMultiSelectConnected"
let kMultiSelectConnectedAndReadOK = "kMultiSelectConnectedAndReadOK"
let bWait = "bWait"
let kWelcomeKey = "Welcome"
let kPolicyKey = "Policy"
let kIsRemoteDeviceConnected = "kIsRemoteDeviceConnected"
let kOTAUpdate = "OTAUpdate"
let kCell = "Cell"
let kValue = "value"
let kA = "a"
let kB = "b"
let kC = "c"

// MARK: - Error

let kErrorNetworkOffline = -1009



