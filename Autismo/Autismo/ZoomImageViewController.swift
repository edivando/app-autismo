//
//  ZoomImageViewController.swift
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 05/11/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit

class ZoomImageViewController: UIViewController {
    
    @IBOutlet var image: UIImageView!
    var index = 0
    var imagesNameList = [""]
    @IBOutlet var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = imagesNameList.count
        pageControl.currentPage = index // set the correct page based on the Prepare for segue information
        let swipeLeft = UISwipeGestureRecognizer (target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer (target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(swipeRight)
        if imagesNameList[index].containsString("userRoutine") {
            image.image = loadImage(imagesNameList[index])
        } else {
            image.image = UIImage(named: imagesNameList[index])
        }
        image.layer.borderWidth = 5.0
        image.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor  ////102 179 224
        image.clipsToBounds = true
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
    
    @IBAction func changePage(sender: UIPageControl) {
        //self.screenNumber.text = [NSString stringWithFormat:@"%i", ([self.pageController currentPage]+1)];
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                pageControl.currentPage--
                if imagesNameList[index].containsString("userRoutine") {
                    image.image = loadImage(imagesNameList[pageControl.currentPage])
                } else {
                    image.image = UIImage(named: imagesNameList[pageControl.currentPage])
                }
            case UISwipeGestureRecognizerDirection.Left:
                pageControl.currentPage++
                if imagesNameList[index].containsString("userRoutine") {
                    image.image = loadImage(imagesNameList[pageControl.currentPage])
                } else {
                    image.image = UIImage(named: imagesNameList[pageControl.currentPage])
                }
            default:
                break
            }
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
