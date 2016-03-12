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
    
    func trackEventInTournament(tournament: Tournament, event: String, matchType: String?) {
        var properties = [GlobalConstants.numEntrants: 0, GlobalConstants.format: ""]
        if let type = tournament.type, entrants = tournament.entrants {
            properties[GlobalConstants.numEntrants] = entrants.count
            properties[GlobalConstants.format] = type
        }
        if let matchType = matchType {
            properties[GlobalConstants.matchType] = matchType
        }
        DataAnalytics.sharedInstance.trackEvent(event, properties: properties)
    }
}
