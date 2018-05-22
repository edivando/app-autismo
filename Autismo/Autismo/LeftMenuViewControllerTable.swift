//
//  LeftMenuViewControllerTable.swift
//  Autismo
//
//  Created by Edivando Alves on 9/15/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit


class LeftMenuViewControllerTable: UITableViewController {

    enum LeftMenuSection :  Int {
        case Rotinas
        //case Donation
        case SobreNos
    }
    
    let options = ["Rotinas".localized, /*"Donation".localized ,*/ "Sobre Nós".localized]
    
    var profiles = [Profile]()
    
//    var profileAtual = Profile()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profiles = ProfileData.dataShared.values()
        if profiles.count > 0{
            if let profile = profiles.first{
                ProfileData.dataShared.profileSelected = profile
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        profiles = ProfileData.dataShared.values()
        tableView.reloadData()
    }


    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180.0
        }
        return 75.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch(section){
        case 0:  return 1.0
        default: return 20.0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:  return 1
        case 1:  return profiles.count
        default: return options.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section){
        case 0:
            if let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as? ProfileTableViewCell{
                cell.name.text = ProfileData.dataShared.profileSelected?.name
                cell.img.image = ProfileData.dataShared.profileSelected?.getImage()  //UIImage(named: "NumbersDuck")
                cell.img.layer.cornerRadius = cell.img.frame.width / 2.0
                cell.img.clipsToBounds = true
                cell.img.layer.borderWidth = 3.0
                cell.img.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCellWithIdentifier("kidsCell", forIndexPath: indexPath) as? KidsTableViewCell{
                cell.name.text = profiles[indexPath.row].name
                cell.img.image = profiles[indexPath.row].getImage()
                cell.img.layer.cornerRadius = cell.img.frame.width / 2.0
                cell.img.clipsToBounds = true
                cell.img.layer.borderWidth = 3.0
                cell.img.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor
                cell.edit = {
                    self.performSegueWithIdentifier("perfilKidsSegue", sender: self.profiles[indexPath.row])
                }
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("cellLeftMenu", forIndexPath: indexPath)
            cell.textLabel?.text = options[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.section){
        case 0:
            closeLeft()
            NSNotificationCenter.defaultCenter().postNotificationName("RefreshGames", object: nil)
//            break;
        case 1:
            closeLeft()
            ProfileData.dataShared.profileSelected = profiles[indexPath.row]
            tableView.reloadData()
            NSNotificationCenter.defaultCenter().postNotificationName("RefreshGames", object: nil)
        default:
            switch LeftMenuSection(rawValue: indexPath.row)! {
                case .Rotinas:
                    performSegueWithIdentifier("routineSegue", sender: nil)
//                case .Donation:
//                    performSegueWithIdentifier("DonationSegue", sender: nil)
                
                case .SobreNos:
                    
                    // First create a UINavigationController (or use your existing one).
                    // The RFAboutView needs to be wrapped in a UINavigationController.
                    
                    let aboutNav = UINavigationController()
                    
                    // Initialise the RFAboutView:
                    
                    let aboutView = RFAboutViewController(appName: "Amora", appVersion: nil, appBuild: nil, copyrightHolderName: "Amora Project", contactEmail: nil, contactEmailTitle: nil, websiteURL: NSURL(string: "website".localized), websiteURLTitle: "Website", pubYear: nil)
                    
                    // Set some additional options:
                    
                    aboutView.headerBackgroundColor = .blackColor()
                    aboutView.headerTextColor = .blackColor()
                    aboutView.blurStyle = .Light
                    aboutView.headerBackgroundImage = UIImage(named: "splash_screen")
                    
                    // Add an additional button:
                    aboutView.addAdditionalButton("Privacy Policy".localized, content: "Here's the privacy policy".localized)
                    aboutView.addAdditionalButton("Facebook Page", content: "facebookWebsite".localized)
                    aboutView.addAdditionalButton("team".localized, content: "teamWebsite".localized)
                    aboutView.addAdditionalButton("Associação Fortaleza Azul", content: "fazWebsite".localized)
                    
                    // Add the aboutView to the NavigationController:
                    aboutNav.setViewControllers([aboutView], animated: false)
                    
                    // Present the navigation controller:
                    self.presentViewController(aboutNav, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func newProfile(sender: AnyObject) {
        performSegueWithIdentifier("perfilKidsSegue", sender: Profile().new())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "perfilKidsSegue" && sender != nil{
            if let controller = segue.destinationViewController as? ProfileViewController, profile = sender as? Profile{
                controller.profile = profile
            }
        }
    }
    
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            
            ProfileData.dataShared.remove(profiles[indexPath.row])
            viewDidAppear(true)
        
            //print("Delete")
        default:
            return
        }
    }


}
