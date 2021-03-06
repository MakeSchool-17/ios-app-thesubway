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
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var randomizeButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = GlobalConstants.backgroundColorVc
        self.clearButton.backgroundColor = GlobalConstants.buttonRedColor
        self.clearButton.tintColor = UIColor.whiteColor()
        self.clearButton.titleLabel!.font = UIFont.systemFontOfSize(40)
        self.clearButton.layer.cornerRadius = 5.0
        self.randomizeButton.backgroundColor = GlobalConstants.buttonGreenColor
        self.randomizeButton.tintColor = UIColor.whiteColor()
        self.randomizeButton.titleLabel!.font = UIFont.systemFontOfSize(40)
        self.randomizeButton.layer.cornerRadius = 5.0
        
        self.calculateNumGroups()
        self.clearGroups()
        self.reloadStackView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func calculateNumGroups() {
        var finalGroups : [[String]] = []
        if self.tournamentData.entrants.count == 4 {
            finalGroups = GroupCalculator.getGroupsOf4Or3(self.tournamentData.entrants)
        }
        if self.tournamentData.entrants.count == 5 {
            finalGroups = GroupCalculator.getGroupsOf5Or6(self.tournamentData.entrants)
        }
        else if self.tournamentData.entrants.count <= 32 {
            finalGroups = GroupCalculator.getGroupsOf4Or3(self.tournamentData.entrants)
        }
        else if self.tournamentData.entrants.count <= 42 {
            finalGroups = GroupCalculator.getGroupsOf5Or6(self.tournamentData.entrants)
        }
        else if self.tournamentData.entrants.count <= 48 {
            finalGroups = GroupCalculator.getnGroups(12, entrants: self.tournamentData.entrants)
        }
        else {
            //so 49-64 teams
            finalGroups = GroupCalculator.getnGroups(16, entrants: self.tournamentData.entrants)
        }
        self.entrantsNotEntered = []
        self.groups = finalGroups
    }
    func reloadStackView() {
        UIHelper.removeSubviewsFrom(self.stackView)
        //set up stackView settings:
        stackView.spacing = 10
        stackView.alignment = UIStackViewAlignment.Center
        let headerHeight = CGFloat(25.0)
        let labelPadding : CGFloat = 5.0
        
        //set up groupView settings:
        let entrantHeight = 50
        let entrantWidth : CGFloat = 250
        let groupNames = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ123456".characters)
        //add groupViews:
        for i in 0 ..< self.groups.count {
            let eachGroup = self.groups[i]
            let vw = UIView()
            vw.heightAnchor.constraintEqualToConstant(headerHeight + CGFloat(entrantHeight * eachGroup.count)).active = true
            vw.widthAnchor.constraintEqualToConstant(entrantWidth).active = true
            vw.tag = i
            vw.layer.cornerRadius = 5.0
            vw.layer.borderWidth = 1
            vw.backgroundColor = GlobalConstants.grayVeryLight
            
            //add group letter
            let groupTitle = UILabel(frame: CGRect(x: labelPadding, y: 0, width: entrantWidth, height: headerHeight))
            groupTitle.text = "Group \(groupNames[i])"
            vw.addSubview(groupTitle)
            
            //add group entrants:
            for j in 0 ..< eachGroup.count {
                let eachEntrant = eachGroup[j]
                let lblY = CGFloat(entrantHeight) * CGFloat(j) + headerHeight
                let lblWidth : CGFloat = 90
                let entrantLabel = UILabel(frame: CGRect(x: labelPadding, y: lblY, width: lblWidth, height: CGFloat(entrantHeight)))
                entrantLabel.text = "Entrant \(j+1):"
                vw.addSubview(entrantLabel)
                
                //add textField for current team:
                let textFieldEntrant = UITextField()
                textFieldEntrant.frame = CGRect(x: lblWidth, y: entrantLabel.frame.origin.y, width: entrantWidth - lblWidth, height: entrantLabel.frame.size.height)
                textFieldEntrant.text = eachEntrant
                
                //add button on top of textField:
                let buttonEntrant = PickerGroupButton(frame: CGRect(x: 0, y: 0, width: textFieldEntrant.frame.width, height: textFieldEntrant.frame.height))
                textFieldEntrant.addSubview(buttonEntrant)
                buttonEntrant.addTarget(self, action: #selector(CreateGroupStageViewController.entrantPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                buttonEntrant.imageView?.contentMode = UIViewContentMode.ScaleToFill
                buttonEntrant.setImage(UIImage(named: "dropDownSelectBox"), forState: UIControlState.Normal)
                buttonEntrant.entrantName = eachEntrant
                buttonEntrant.groupIdx = i
                buttonEntrant.entrantIdx = j
                vw.addSubview(textFieldEntrant)
            }
            self.stackView.addArrangedSubview(vw)
        }
        self.updateButton()
    }
    
    func updateButton() {
        if self.entrantsNotEntered.count > 0 {
            self.submitButton.backgroundColor = UIColor.redColor()
            self.submitButton.tintColor = UIColor.whiteColor()
        }
        else {
            self.submitButton.backgroundColor = UIColor.greenColor()
            self.submitButton.tintColor = UIColor.blackColor()
        }
    }
    
    func entrantPressed(sender: PickerGroupButton) {
        var entrantArr : [String] = self.entrantsNotEntered
        entrantArr.append(GlobalConstants.strEmpty)
        if sender.entrantName != GlobalConstants.strEmpty {
            entrantArr.append(sender.entrantName!)
        }
        MMPickerView.showPickerViewInView(self.view, withObjects: entrantArr, withOptions: nil, objectToStringConverter: nil) { (selectedString : AnyObject!) -> Void in
            if String(selectedString!) == sender.entrantName {
                //cancel:
                return
            }
            else if String(selectedString!) == GlobalConstants.strEmpty {
                //set current entrant from array to empty.
                self.groups[sender.groupIdx][sender.entrantIdx] = GlobalConstants.strEmpty
                self.entrantsNotEntered.append(sender.entrantName)
            }
            else {
                //replace previous name with new name
                self.groups[sender.groupIdx][sender.entrantIdx] = selectedString as! String
                self.entrantsNotEntered = AlgorithmUtil.removedFromArr(self.entrantsNotEntered, element: selectedString as! String)
                //if previous name was an existing name:
                if sender.entrantName != GlobalConstants.strEmpty {
                    self.entrantsNotEntered.append(sender.entrantName)
                }
            }
            self.reloadStackView()
        }
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
        self.tournamentData.groups = self.groups
        self.tournamentData.bracketSlots = BracketCalculator.calculateGroupBrackets(groups, tournamentData: self.tournamentData)
        CoreDataUtil.addTournament(tournamentData)
        self.navigationController?.popToRootViewControllerAnimated(true)
        //go to knockout stage:
        /*let createKnockout = self.storyboard?.instantiateViewControllerWithIdentifier("createKnockout") as! CreateKnockoutViewController
        createKnockout.groups = self.groups
        createKnockout.tournamentData = self.tournamentData
        self.navigationController?.pushViewController(createKnockout, animated: true)*/
    }
    
    @IBAction func randomizePressed(sender: AnyObject) {
        self.calculateNumGroups()
        self.reloadStackView()
        DataAnalytics.sharedInstance.trackEvent(GlobalConstants.buttonPressed, properties: [GlobalConstants.buttonName: GlobalConstants.randomize])
    }
    
    @IBAction func clearPressed(sender: AnyObject) {
        self.clearGroups()
        DataAnalytics.sharedInstance.trackEvent(GlobalConstants.buttonPressed, properties: [GlobalConstants.buttonName: GlobalConstants.clear])
    }
    
    func clearGroups() {
        for i in 0 ..< self.groups.count {
            let eachGroup = self.groups[i]
            for j in 0 ..< eachGroup.count {
                if self.groups[i][j] != GlobalConstants.strEmpty {
                    self.entrantsNotEntered.append(self.groups[i][j])
                    self.groups[i][j] = GlobalConstants.strEmpty
                }
            }
        }
        self.reloadStackView()
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
