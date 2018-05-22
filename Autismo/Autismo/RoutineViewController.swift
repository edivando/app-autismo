//
//  RoutineViewController.swift
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 04/11/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit
import Foundation

class RoutineViewController: UIViewController {
    
    var imageNames = [[]]
    var index = 0
    var routines = [Routine]()
    var userRoutine =  UserRoutine()
    var addedRoutines = [Routine]()
    let routineIdentifier = "routineIdentifier" //identifier to get info from plist
    let defaultImage = "amoraIconEmptySpot"

    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var routineImages: [UIImageView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        routines = Routine.loadRoutines() //get the routines from the routines.json
        addedRoutines = userRoutine.getPlistRoutine(routineIdentifier) // get the routines added by the user
        for routineCollection in addedRoutines {
            if routineCollection.identifier != "nil" {
                routines.append(routineCollection) //put all the routines in the same array
            }
        }
        imageNames = routines[index].imageNames //get the images for the touched position
        
        pageControl.numberOfPages = imageNames.count
        let swipeLeft = UISwipeGestureRecognizer (target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer (target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(swipeRight)
        
        for imageView in routineImages {
            let tapGesture = UITapGestureRecognizer (target: self, action: "respondToTapGesture:")
            imageView.addGestureRecognizer(tapGesture)
            imageView.layer.borderWidth = 5.0
            imageView.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor  ////102 179 224
            imageView.clipsToBounds = true
        }
        
        for image in routineImages { //set the default for the empty spots and disable the user interaction
            image.image = UIImage(named: defaultImage)
            image.userInteractionEnabled = false
        }
        
        for (index,image) in imageNames[pageControl.currentPage].enumerate() {
            if let imageName = image as? String {
                if imageName.containsString("userRoutine") { //load the images added by the user
                    routineImages[index].image = loadImage(imageName)
                } else { //load the imagens from the Images.xcassets
                    routineImages[index].image = UIImage(named: imageName)
                }
                routineImages[index].userInteractionEnabled = true
            }
        }
        navigationController?.navigationBarHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        userRoutine = UserRoutine()
        navigationController?.navigationBarHidden = true
    }
    
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            for image in routineImages {
                image.image = UIImage(named: defaultImage)
                image.userInteractionEnabled = false
            }
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                pageControl.currentPage--
                
                for (index,image) in imageNames[pageControl.currentPage].enumerate() {
                    if image.containsString("userRoutine") { //load the images added by the user
                        routineImages[index].image = loadImage(image as! String)
                    } else { //load the imagens from the Images.xcassets
                        routineImages[index].image = UIImage(named: image as! String)
                    }
                    routineImages[index].userInteractionEnabled = true

                }
                
            case UISwipeGestureRecognizerDirection.Left:
                pageControl.currentPage++
                for (index,image) in imageNames[pageControl.currentPage].enumerate() {
                    if image.containsString("userRoutine") { //load the images added by the user
                        routineImages[index].image = loadImage(image as! String)
                    } else { //load the imagens from the Images.xcassets
                        routineImages[index].image = UIImage(named: image as! String)
                    }
                    routineImages[index].userInteractionEnabled = true

                }
            default:
                break
            }
        }
    }
    
    func respondToTapGesture (gesture: UIGestureRecognizer) {
        if pageControl.currentPage > 0 { //check the page to adjust the correct number of the array in the ZoomSegue, each page has only 4 images
            if let imageTag = gesture.view?.tag {
            performSegueWithIdentifier("zoomSegue", sender: (imageTag + 4*(pageControl.currentPage)))
            }
            
        } else {
            performSegueWithIdentifier("zoomSegue", sender: gesture.view?.tag)

        }

    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "zoomSegue" && segue.destinationViewController.isKindOfClass(ZoomImageViewController.classForCoder()) {
            if let controller = segue.destinationViewController as? ZoomImageViewController, let index = sender as? Int {
                controller.index = index
                var imageSequence : [String] = []
                for imageArray in imageNames {
                    for image in imageArray {
                        imageSequence.append(image as! String)
                    }
                }
                controller.imagesNameList = imageSequence //pass the list of all the images from all the pages for the present routine
                
            }
        }
    }
    
}
