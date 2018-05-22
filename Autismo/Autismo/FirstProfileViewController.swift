//
//  FirstProfileViewController.swift
//  Autismo
//
//  Created by Edivando Alves on 11/10/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit

class FirstProfileViewController: UIViewController, GMImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UITextField!
    
    var imagePicker = GMImagePickerController()
    var games = [Game]()
    
    let profile = Profile().new()
    
    
    deinit {
        NSNotificationCenter.defaultCenter().postNotificationName("IntroMain", object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.cornerRadius = userImage.frame.width / 2.0
        userImage.clipsToBounds = true
        userImage.layer.borderWidth = 3.0
        userImage.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor  ////102 179 224
        userImage.image = profile.getImage()
        userName.placeholder = "Seu nome".localized
//        userName.text = profile.name
        
        let singleTap = UITapGestureRecognizer(target: self, action: "editImage:")
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        userImage.addGestureRecognizer(singleTap)
        userImage.userInteractionEnabled = true
        
        self.games = Game.loadGames()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func editImage(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.Ended){
            
            imagePicker.delegate = self
            
            imagePicker.title = "Gallery".localized
            imagePicker.customNavigationBarPrompt = "Pick a picute".localized
            imagePicker.colsInPortrait = 3;
            imagePicker.colsInLandscape = 5;
            imagePicker.minimumInteritemSpacing = 2.0;
            
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func assetsPickerController(picker: GMImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        if let info = assets{
            if let asset = info[0] as? PHAsset{
                let image = getAssetThumbnail(asset)
                userImage.image = image
                UIImagePNGRepresentation(image)?.saveInFile("\(profile.id).png")
                profile.setImage(image)
            }
            //print(info[0])
        }
        
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func assetsPickerControllerDidCancel(picker: GMImagePickerController!) {
        
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 300.0, height: 300.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    @IBAction func save(sender: AnyObject) {
        if let name = userName.text{
            profile.name = name
            ProfileData.dataShared.save( profile )
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
