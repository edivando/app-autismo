//
//  NewRoutineViewController.swift
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 09/11/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit
import Photos


class NewRoutineViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GMImagePickerControllerDelegate {
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var routineImages: [UIImageView]!
    var imagePickerRoutines = UIImagePickerController()
    var gmImagePicker = GMImagePickerController()
    var imageTag = 0
    var routineName = "My Routine".localized
    var userImages = [String]()
    let userRoutine =  UserRoutine()
    let routineImageIdentifier = "routineImageIdentifier" //identifier to get info from plist
    let routineNumberIdentifier = "routineNumberIdentifier" //identifier to get info from plist
    let routineIdentifier = "routineIdentifier" //identifier to get info from plist
    let unhighlightedImage = "cameraOff" //image for the user interation disabled
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pageControl.numberOfPages = 1 //set the initial number of pages
        for (index,imageView) in routineImages.enumerate() {
            let tapGesture = UITapGestureRecognizer (target: self, action: "respondToTapGesture:")
            imageView.addGestureRecognizer(tapGesture)
            imageView.layer.borderWidth = 5.0
            imageView.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor  ////102 179 224
            imageView.clipsToBounds = true
            if index == 0 {
                imageView.highlighted = true // change the first image to represent the enabled status
            } else {
                imageView.image = UIImage(named: unhighlightedImage) //disable the interaction from all the other images on the page
                imageView.userInteractionEnabled = false
                imageView.highlighted = false
            }
        }
        
        let swipeLeft = UISwipeGestureRecognizer (target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer (target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(swipeRight)
        navigationController?.navigationBarHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
    
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveRoutine(sender: UIButton) {
        if userImages != [] {
            let alert = UIAlertController(title: "Do you want to save this routine?".localized, message: "It may take some time.".localized, preferredStyle: .Alert) // 1
            let firstAction = UIAlertAction(title: "Yes".localized, style: .Default) { (alert: UIAlertAction!) -> Void in
                
                let alertC = UIAlertController(title: "What is the name of this routine?".localized, message: nil, preferredStyle: .Alert) // 1
                let firstAction = UIAlertAction(title: "Save".localized, style: .Default) { (alert: UIAlertAction!) -> Void in
                    let tf = alertC.textFields![0]
                    self.routineName = tf.text! //get the routine name from the user
                    let routineNumber = Int(self.userRoutine.routineNumber.last!)! + 1 //update the routine number to save a new one
                    self.userRoutine.setPlistString(self.routineNumberIdentifier, routine: "\(routineNumber)") //save the new routine number in the plist
                    self.userRoutine.setPlistRoutine(routineNumber, routineName: self.routineName) //save the routine in the plist
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                } // 2
                
                let secondAction = UIAlertAction(title: "Cancel".localized, style: .Cancel) { (alert: UIAlertAction!) -> Void in
                }

                alertC.addAction(firstAction) //3
                alertC.addAction(secondAction) //3
                alertC.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
                    textField.placeholder = "My routine".localized
                    
                } // 4
                self.presentViewController(alertC, animated: true, completion: nil) //5
                
                
            } // 2
            let secondAction = UIAlertAction(title: "No".localized, style: .Default) { (alert: UIAlertAction!) -> Void in
            } // 3
            alert.addAction(firstAction) // 4
            alert.addAction(secondAction) // 5
            presentViewController(alert, animated: true, completion:nil) // 6
            
        } else { //don't allow the use to save empty routines
            let alert = UIAlertController(title: "No images alert".localized, message: "Please add at least one image.".localized, preferredStyle: .Alert) // 1
            let firstAction = UIAlertAction(title: "OK".localized, style: .Default) { (alert: UIAlertAction!) -> Void in
            } // 2
            
            alert.addAction(firstAction) //3
            presentViewController(alert, animated: true, completion:nil) //4
        }
        
        
    }
    
    
    func respondToTapGesture(gesture: UIGestureRecognizer) {
        if(gesture.state == UIGestureRecognizerState.Ended){ //open the camera or library to get an image from the user
            imageTag = (gesture.view?.tag)!
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                gmImagePicker = GMImagePickerController()
                gmImagePicker.delegate = self
                gmImagePicker.title = "Gallery".localized
                gmImagePicker.customNavigationBarPrompt = "Pick a picute".localized
                gmImagePicker.colsInPortrait = 3
                gmImagePicker.colsInLandscape = 5
                gmImagePicker.minimumInteritemSpacing = 2.0
                
                gmImagePicker.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
                
                presentViewController(self.gmImagePicker, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Choose were you'll get the picture.".localized, message: nil, preferredStyle: .ActionSheet) // 1
                let firstAction = UIAlertAction(title: "Gallery".localized, style: .Default) { (alert: UIAlertAction!) -> Void in
                    self.gmImagePicker = GMImagePickerController()
                    self.gmImagePicker.delegate = self
                    self.gmImagePicker.title = "Gallery".localized
                    self.gmImagePicker.customNavigationBarPrompt = "Pick a picute".localized
                    self.gmImagePicker.colsInPortrait = 3
                    self.gmImagePicker.colsInLandscape = 5
                    self.gmImagePicker.minimumInteritemSpacing = 2.0
                    
                    self.gmImagePicker.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
                    
                    self.presentViewController(self.gmImagePicker, animated: true, completion: nil)
                    
                } // 2
                let secondAction = UIAlertAction(title: "Camera".localized, style: .Default) { (alert: UIAlertAction!) -> Void in
                    self.imagePickerRoutines.delegate = self
                    //imagePickerRoutines.allowsEditing = true
                    self.imagePickerRoutines.sourceType = .Camera
                    self.presentViewController(self.imagePickerRoutines, animated: true, completion: nil)
                }
                
                let thirdAction = UIAlertAction(title: "Cancel".localized, style: .Cancel) { (alert: UIAlertAction!) -> Void in
                }
                
                alert.addAction(firstAction) //3
                alert.addAction(secondAction)
                alert.addAction(thirdAction)
                alert.popoverPresentationController!.sourceRect = self.routineImages[imageTag].bounds
                alert.popoverPresentationController!.sourceView = self.routineImages[imageTag]
                
                presentViewController(alert, animated: true, completion:nil) //4
                
            }
            
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                if pageControl.currentPage > 0 {
                    pageControl.currentPage--
                    if userImages.count > 0 {
                        for (index,image) in routineImages.enumerate() { //load the images from the previous page
                            routineImages[index].contentMode = .ScaleAspectFill
                            image.highlighted = false
                            image.userInteractionEnabled = true
                            if pageControl.currentPage > 0 { //check the page to adjust the correct number of the array in the ZoomSegue, each page has only 4 images
                                image.image = loadImage(userImages[index + 4*(pageControl.currentPage)])
                            } else {
                                image.image = loadImage(userImages[index])
                            }
                            
                        }
                    }
                }
            case UISwipeGestureRecognizerDirection.Left:
                pageControl.currentPage++
                var containImage = false
                var imageCount = 0
                
                for image in userImages {
                    if image.containsString("page_\(pageControl.currentPage)") {
                        containImage = true
                        imageCount++
                        //print(image)
                    }
                }
                
                for (index,image) in routineImages.enumerate() { //set up to prepare a new page for the user
                    routineImages[index].contentMode = .ScaleAspectFit
                    if index == imageCount {
                        image.highlighted = true //only allow user interaction on the first image of the page
                    } else {
                        image.image = UIImage(named: unhighlightedImage)
                        image.userInteractionEnabled = false
                        image.highlighted = false
                    }
                    
                }
                
                
                
                if containImage == true{
                    for (index,image) in routineImages.enumerate() {
                        if index < imageCount {
                            routineImages[index].contentMode = .ScaleAspectFill
                            image.highlighted = false
                            image.userInteractionEnabled = true
                            if pageControl.currentPage > 0 { //check the page to adjust the correct number of the array in the ZoomSegue, each page has only 4 images
                                image.image = loadImage(userImages[index + 4*(pageControl.currentPage)])
                            } else {
                                if userImages.count > 0 {
                                    image.image = loadImage(userImages[index])
                                }
                            }
                        }
                        
                    }
                }
                
            default:
                break
            }
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePickerRoutines.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{ //get the user image
            routineImages[imageTag].contentMode = .ScaleAspectFill
            routineImages[imageTag].highlighted = false //set the image state to the normal state
            if imageTag == 3 {
                pageControl.numberOfPages++ //if the user add the last image of the page, then create a new page
            } else {
                if !routineImages[imageTag + 1].userInteractionEnabled {
                    routineImages[imageTag + 1].highlighted = true //enable the next image for the user interaction
                    routineImages[imageTag + 1].userInteractionEnabled = true
                }
            }
            routineImages[imageTag].image = image //update the image on the screen
            
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil) //save picture to the phone library
            let number = Int(userRoutine.routineNumber.last!)! + 1 //get the next routine number
            let userImageName = "userRoutine_".stringByAppendingString("image_\(imageTag)_" + "page_\(pageControl.currentPage)_" + "number_\(number)" + ".png")
            if imageTag + 4*(pageControl.currentPage) < userImages.count {
                userImages[(userImages.indexOf(userImageName)!)] = userImageName
                
            } else {
                
                userImages.append(userImageName) //save the user image name
            }
            
            if pageControl.currentPage > 0 { //check the page to adjust the correct number of the array in the ZoomSegue, each page has only 4 images
                UIImagePNGRepresentation(UIImage.rotateCameraImageToProperOrientation(image, maxResolution: 1024.0))?.saveInFile(userImages[imageTag + 4*(pageControl.currentPage)]) //save the image in the app file system
                userRoutine.setPlistString(routineImageIdentifier, routine: userImages[imageTag + 4*(pageControl.currentPage)]) //save the image name in the plist
            } else {
                UIImagePNGRepresentation(UIImage.rotateCameraImageToProperOrientation(image, maxResolution: 1024.0))?.saveInFile(userImages[imageTag]) //save the image in the app file system
                userRoutine.setPlistString(routineImageIdentifier, routine: userImages[imageTag]) //save the image name in the plist
            }
            
        }
    }
    
    func assetsPickerController(picker: GMImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        if let info = assets {
            if let asset = info[0] as? PHAsset {
                let image = getAssetImage(asset)
                picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                routineImages[imageTag].contentMode = .ScaleAspectFill
                routineImages[imageTag].highlighted = false //set the image state to the normal state
                if imageTag == 3 {
                    pageControl.numberOfPages++ //if the user add the last image of the page, then create a new page
                } else {
                    if !routineImages[imageTag + 1].userInteractionEnabled {
                        routineImages[imageTag + 1].highlighted = true //enable the next image for the user interaction
                        routineImages[imageTag + 1].userInteractionEnabled = true
                    }
                }
                routineImages[imageTag].image = image //update the image on the screen
                
                let number = Int(userRoutine.routineNumber.last!)! + 1 //get the next routine number
                let userImageName = "userRoutine_".stringByAppendingString("image_\(imageTag)_" + "page_\(pageControl.currentPage)_" + "number_\(number)" + ".png")
                if imageTag + 4*(pageControl.currentPage) < userImages.count {
                    userImages[(userImages.indexOf(userImageName)!)] = userImageName
                    
                } else {
                    
                    userImages.append(userImageName) //save the user image name
                }
                
                if pageControl.currentPage > 0 { //check the page to adjust the correct number of the array in the ZoomSegue, each page has only 4 images
                    UIImagePNGRepresentation(UIImage.rotateCameraImageToProperOrientation(image, maxResolution: 1024.0))?.saveInFile(userImages[imageTag + 4*(pageControl.currentPage)]) //save the image in the app file system
                    userRoutine.setPlistString(routineImageIdentifier, routine: userImages[imageTag + 4*(pageControl.currentPage)]) //save the image name in the plist
                } else {
                    UIImagePNGRepresentation(UIImage.rotateCameraImageToProperOrientation(image, maxResolution: 1024.0))?.saveInFile(userImages[imageTag]) //save the image in the app file system
                    userRoutine.setPlistString(routineImageIdentifier, routine: userImages[imageTag]) //save the image name in the plist
                }
                
            }
        }
    }
    
    func getAssetImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.synchronous = true
        manager.requestImageDataForAsset(asset, options: option) { (imageData: NSData?, dataUTI: String?, orientation: UIImageOrientation, info: [NSObject : AnyObject]?) -> Void in
            image = (imageData?.image())!
        }
        
        return image
    }
    
    
    func image(image: UIImage, didFinishSavingWithError: NSErrorPointer, contextInfo:UnsafePointer<Void>)       {
        
        if (didFinishSavingWithError != nil) {
            //print("Error saving photo: \(didFinishSavingWithError)")
        } else {
            //print("Successfully saved photo, will make request to update asset metadata")
            
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
