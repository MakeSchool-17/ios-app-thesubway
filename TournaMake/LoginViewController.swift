//
//  ViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/14/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldEmail.delegate = self
        self.textFieldPassword.delegate = self
        self.textFieldPassword.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(sender: AnyObject) {
        let mytournaments = self.storyboard?.instantiateViewControllerWithIdentifier("mytournaments") as! MyTournamentsViewController
        self.navigationController?.pushViewController(mytournaments, animated: true)
    }

    @IBAction func signUpPressed(sender: AnyObject) {
        let signup = self.storyboard?.instantiateViewControllerWithIdentifier("signup") as! SignUpViewController
        self.navigationController?.pushViewController(signup, animated: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

