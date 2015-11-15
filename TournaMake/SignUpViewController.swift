//
//  SignUpViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/14/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var textFieldConfirmPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signupPressed(sender: AnyObject) {
        print("sign up")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
