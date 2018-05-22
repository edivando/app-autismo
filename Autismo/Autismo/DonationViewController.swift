//
//  DonationViewController.swift
//  Autismo
//
//  Created by Flávio Tabosa on 11/23/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import Foundation

class DonationViewController: UIViewController {
    
    //@IBOutlet var donateButton: UIButton!
    let iAPHelper = IAPHelper()
    
    @IBOutlet weak var donateLabel: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var ramonImage: UIImageView!
    @IBOutlet weak var ryvaneImage: UIImageView!
    @IBOutlet weak var flavioImage: UIImageView!
    @IBOutlet weak var edivandoImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        donateLabel.text = "Donate to Us".localized
        thanksLabel.text = "Thanks!!".localized
        ramonImage.layer.borderWidth = 3.0
        ramonImage.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor  ////102 179 224
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            ramonImage.layer.cornerRadius =  50
        }else{
            ramonImage.layer.cornerRadius =  90
        }
        ramonImage.clipsToBounds = true
        
        
        ryvaneImage.layer.borderWidth = 3.0
        ryvaneImage.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor  ////102 179 224
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            ryvaneImage.layer.cornerRadius =  50
        }else{
            ryvaneImage.layer.cornerRadius =  90
        }
        ryvaneImage.clipsToBounds = true

        
        flavioImage.layer.borderWidth = 3.0
        flavioImage.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor  ////102 179 224
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            flavioImage.layer.cornerRadius =  50
        }else{
            flavioImage.layer.cornerRadius =  90
        }
        flavioImage.clipsToBounds = true

        
        edivandoImage.layer.borderWidth = 3.0
        edivandoImage.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor  ////102 179 224
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            edivandoImage.layer.cornerRadius =  50
        }else{
            edivandoImage.layer.cornerRadius =  90
        }
        edivandoImage.clipsToBounds = true

        
        
        //donateButton.setTitle("Donate to Us".localized, forState: .Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        let alertController = UIAlertController(title: "Donate to Us".localized, message:
            "DonateDescription".localized, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok!", style: .Cancel, handler: { action in
            //print("Click of cancel button")
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func donationAlert(sender: UIButton) {
        let alertController = UIAlertController(title: "Donate to Us".localized, message:
            "ThankYou Message".localized, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Donate".localized, style: .Default, handler: { action in
            //Finish Donation
            self.iAPHelper.buyProductWithIdentifier("com.bepid.Autismo.Donation\(sender.tag)")
            //print("END OF DONATION")
            
            
        }))
        
        
        
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .Cancel, handler: { action in
            //print("Click of cancel button")
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func back(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}