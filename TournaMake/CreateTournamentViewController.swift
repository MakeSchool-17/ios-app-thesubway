//
//  CreateTournamentViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/17/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class CreateTournamentViewController: UIViewController {

    @IBOutlet var typePicker: UITextField!
    @IBOutlet var textFieldTournamentName: UITextField!
    @IBOutlet var textViewEntrants: UITextView!
    @IBOutlet var labelTotalTeams: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let typeButton = UIButton(frame: CGRect(x: 0, y: 0, width: typePicker.frame.width, height: typePicker.frame.height))
        self.typePicker.addSubview(typeButton)
        typeButton.addTarget(self, action: "typePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.textViewEntrants.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func typePressed(sender: UIButton) {
        print("type pressed")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func submitPressed(sender: AnyObject) {
        print("submit")
    }

}
