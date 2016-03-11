//
//  DataAnalytics.swift
//  TournaMake
//
//  Created by Dan Hoang on 3/9/16.
//  Copyright © 2016 Dan Hoang. All rights reserved.
//

import UIKit
import Mixpanel

class DataAnalytics {
    static let sharedInstance = DataAnalytics()
    var mixPanel : Mixpanel
    
    private init() {
        if let path = NSBundle.mainBundle().pathForResource("Secrets", ofType: "plist"), dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            // use swift dictionary as normal
            var tokenKey = "mixPanelToken"
            if _isDebugAssertConfiguration() {
                tokenKey = "mixPanelTokenDevelopment"
            }
            let mixPanelToken = dict[tokenKey] as! String
            Mixpanel.sharedInstanceWithToken(mixPanelToken)
        }
        self.mixPanel = Mixpanel.sharedInstance()
    }
    
    func trackEvent(event: String, properties: [NSObject : AnyObject]) {
        self.mixPanel.track(event, properties: properties)
    }
}
