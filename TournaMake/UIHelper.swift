//
//  UIHelper.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/17/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class UIHelper {
    
    class func showAlertOnVc(viewController : UIViewController, title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { _ in
        })
        alert.addAction(okAction)
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func removeSubviewsFrom(view : UIView?) {
        if let stackView = view as? UIStackView {
            while stackView.arrangedSubviews.count > 0 {
                let eachSubview = stackView.arrangedSubviews[0]
                eachSubview.removeFromSuperview()
                stackView.removeArrangedSubview(eachSubview)
            }
        }
        else if let view = view {
            while view.subviews.count > 0 {
                let eachSubview = view.subviews[0]
                eachSubview.removeFromSuperview()
            }
        }
    }
    
}