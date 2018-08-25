//
//  GoogleAnalyticsManager.swift
//  Jouz
//
//  Created by ANKER on 2018/1/25.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class GoogleAnalyticsManager: NSObject {
    
    static let sharedInstance = GoogleAnalyticsManager()
    
    func trackEvent(category: GoogleAnalyticsEventCategory, action: GoogleAnalyticsEventAction, label: String? = nil) {
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: category.rawValue, action: action.rawValue, label: label == nil ? "\(action.rawValue)_count" : label!, value: 1).build() as? [AnyHashable : Any])
    }
}

enum GoogleAnalyticsEventCategory: String {
    // Jouz
    case app_event = "app_event"
    case app_switch_language = "app_switch_language"
    
}

enum GoogleAnalyticsEventAction: String {
    // Jouz
    case start_app_datetime = "start_app_datetime"
    case start_app = "start_app"
    case connecting_bluetooth = "connecting_bluetooth"
    case connect_bluetooth_success = "connect_bluetooth_success"
    case connect_bluetooth_failed = "connect_bluetooth_failed"
    case user_manual = "user_manual"
    case user_disconnect = "user_disconnect"
    case ota = "ota"
    case ota_success = "ota_success"
    case rename = "rename"
    case jouz_website = "jouz_website"
    case lang_en = "lang_en"
    case lang_Ja = "lang_Ja"
    case terms_user = "terms_user"
    case privacy_policy = "privacy_policy"
    case shopping = "shopping"
    case shopping_time = "shopping_time"
    case disconnect = "disconnect"
}

enum GoogleAnalyticsEventLabel: String {
    // Jouz
    case count = "count"
    
}
