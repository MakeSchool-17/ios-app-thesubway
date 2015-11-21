//
//  CreateGroupStageViewController.swift
//  TournaMake
//
//  Created by Dan Hoang on 11/18/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class CreateGroupStageViewController: UIViewController {

    var tournamentData : TournamentData!
    var groups : [[String]]!
    var entrantsNotEntered : [String] = []
    let strEmpty = "*Empty*"
    @IBOutlet var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableViewGroups.dataSource = self
//        self.tableViewGroups.delegate = self
        self.groups = self.calculateNumGroups()
        
        self.reloadStackView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func calculateNumGroups() -> [[String]] {
        var finalGroups : [[String]] = []
        
        if self.tournamentData.entrants.count <= 32 {
            finalGroups = GroupCalculator.getGroupsOf4Or3(self.tournamentData.entrants)
        }
        return finalGroups
    }
    func reloadStackView() {
        //clear previous data
        for var i = 0; i < self.stackView.arrangedSubviews.count; i++ {
            let eachSubview = self.stackView.arrangedSubviews[i]
            eachSubview.removeFromSuperview()
            self.stackView.removeArrangedSubview(eachSubview)
            i--
        }
        //set up stackView settings:
        stackView.spacing = 10
        stackView.alignment = UIStackViewAlignment.Center
        let headerHeight = CGFloat(25.0)
        
        //set up groupView settings:
        let entrantHeight = 50
        let entrantWidth : CGFloat = 250
        let groupNames = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ123456".characters)
        //add groupViews:
        for var i = 0; i < self.groups.count; i++ {
            let eachGroup = self.groups[i]
            let vw = NSBundle.mainBundle().loadNibNamed("GroupView", owner: nil, options: nil)[0] as! GroupView
            vw.heightAnchor.constraintEqualToConstant(headerHeight + CGFloat(entrantHeight * eachGroup.count)).active = true
            vw.widthAnchor.constraintEqualToConstant(entrantWidth).active = true
            vw.tag = i
            vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            
            //add group letter
            let groupTitle = UILabel(frame: CGRect(x: 0, y: 0, width: entrantWidth, height: headerHeight))
            groupTitle.text = "Group \(groupNames[i])"
            vw.addSubview(groupTitle)
            
            //add group entrants:
            for var j = 0; j < eachGroup.count; j++ {
                let eachEntrant = eachGroup[j]
                let lblY = CGFloat(entrantHeight) * CGFloat(j) + headerHeight
                let lblWidth : CGFloat = 90
                let entrantLabel = UILabel(frame: CGRect(x: 0.0, y: lblY, width: lblWidth, height: CGFloat(entrantHeight)))
                entrantLabel.text = "Entrant \(j+1):"
                vw.addSubview(entrantLabel)
                
                //add textField for current team:
                let textFieldEntrant = UITextField()
                textFieldEntrant.frame = CGRect(x: lblWidth, y: entrantLabel.frame.origin.y, width: entrantWidth - lblWidth, height: entrantLabel.frame.size.height)
                textFieldEntrant.text = eachEntrant
                
                //add button on top of textField:
                let buttonEntrant = PickerButton(frame: CGRect(x: 0, y: 0, width: textFieldEntrant.frame.width, height: textFieldEntrant.frame.height))
                textFieldEntrant.addSubview(buttonEntrant)
                buttonEntrant.addTarget(self, action: "entrantPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                buttonEntrant.entrantName = eachEntrant
                buttonEntrant.groupIdx = i
                buttonEntrant.entrantIdx = j
                vw.addSubview(textFieldEntrant)
            }
            self.stackView.addArrangedSubview(vw)
        }
    }
    func entrantPressed(sender: PickerButton) {
        var entrantArr : [String] = self.entrantsNotEntered
        entrantArr.append(self.strEmpty)
        if sender.entrantName != self.strEmpty {
            entrantArr.append(sender.entrantName!)
        }
        MMPickerView.showPickerViewInView(self.view, withObjects: entrantArr, withOptions: nil, objectToStringConverter: nil) { (selectedString : AnyObject!) -> Void in
            if String(selectedString!) == sender.entrantName {
                //cancel:
                return
            }
            else if String(selectedString!) == self.strEmpty {
                //set current entrant from array to empty.
                self.groups[sender.groupIdx][sender.entrantIdx] = self.strEmpty
                self.entrantsNotEntered.append(sender.entrantName)
            }
            else {
                //replace previous name with new name
                self.groups[sender.groupIdx][sender.entrantIdx] = selectedString as! String
                self.entrantsNotEntered = self.removedFromArr(self.entrantsNotEntered, element: selectedString as! String)
                //if previous name was an existing name:
                if sender.entrantName != self.strEmpty {
                    self.entrantsNotEntered.append(sender.entrantName)
                }
            }
            self.reloadStackView()
        }
    }
    func removedFromArr(inArr : [String], element : String) -> [String] {
        let outArr = inArr.filter() { $0 != element }
        return outArr
    }
    @IBAction func submitPressed(sender : AnyObject?) {
        if self.entrantsNotEntered.count > 0 {
            var strMissing = "\nEntrants missing:"
            for eachMissing in self.entrantsNotEntered {
                strMissing += "\n\(eachMissing)"
            }
            UIHelper.showAlertOnVc(self, title: "", message: strMissing)
            return
        }
        //go to knockout stage:
        let createKnockout = self.storyboard?.instantiateViewControllerWithIdentifier("createKnockout") as! CreateKnockoutViewController
        createKnockout.groups = self.groups
        createKnockout.tournamentData = self.tournamentData
        self.navigationController?.pushViewController(createKnockout, animated: true)
    }
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return self.groups.count
//    }
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let currentGroup = self.groups[section]
//        return currentGroup.count
//    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("createGroupSlotCell") as! CreateGroupSlotCell
//        let currentGroup = self.groups[indexPath.section]
//        let currentEntrant = currentGroup[indexPath.row]
//        cell.textLabel?.text = currentEntrant
//        return cell
//    }

}
