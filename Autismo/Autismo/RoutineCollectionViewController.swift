//
//  RoutineCollectionViewController.swift
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 04/11/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit

class RoutineCollectionViewController: UICollectionViewController {
    
    var routines = [Routine]()
    var userRoutine = UserRoutine()
    var addedRoutines = [Routine]()
    let routineIdentifier = "routineIdentifier"
    let addImage = "add"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        routines = Routine.loadRoutines() //get the routines from the routine.json
        addedRoutines = userRoutine.getPlistRoutine(routineIdentifier) //get the user added routines
        for routineCollection in addedRoutines {
            if routineCollection.identifier != "nil" {
                routines.append(routineCollection) //put all the routines in the same array
            }
        }
        navigationController?.navigationBarHidden = true
//        setOrientation(.LandscapeRight)
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        userRoutine = UserRoutine()
        routines = Routine.loadRoutines()
        addedRoutines = userRoutine.getPlistRoutine(routineIdentifier)
        for routineCollection in addedRoutines {
            if routineCollection.identifier != "nil" {
                routines.append(routineCollection)
            }
        }
        navigationController?.navigationBarHidden = true
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routines.count + 1 // add one more to be the "ADD Routine" action
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellRoutine", forIndexPath: indexPath) as! RoutineCollectionViewCell
        
        // Configure the cell
        if indexPath.row == routines.count{ // this is the "ADD Routine" action
            cell.routineImage.image = UIImage (named: addImage) //cell to add new routines
            cell.routineName.text = "Add New".localized
            
        } else { //this is a normal routine
            cell.routineImage.image = UIImage (named: routines[indexPath.row].background) //normal routines
            cell.routineName.text = routines[indexPath.row].name.localized

        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "sectionRoutineHeader", forIndexPath: indexPath)
            return view
        }
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "sectionRoutineFooter", forIndexPath: indexPath)
        return view
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == routines.count { //this is the "ADD Routine" action
            performSegueWithIdentifier("addRoutineSegue", sender: indexPath.row)
        } else { // this is a normal routine
            performSegueWithIdentifier("routineSegue", sender: indexPath.row)
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "routineSegue" && segue.destinationViewController.isKindOfClass(RoutineViewController.classForCoder()) {
            if let controller = segue.destinationViewController as? RoutineViewController, let index = sender as? Int {
                controller.index = index //send position that was touched
                
            }
        }
    }
    
    
    // MARK: - UICollectionViewFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 10 //set the left and right borders space
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let upperInset = self.view.frame.size.height / 5 //set the upper border space
            return UIEdgeInsetsMake(upperInset, leftRightInset, 0, leftRightInset)
        } else {
            return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 150, height: 150) //return the size of each cell
    }
    
    //MARK: Action
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tutorial(sender: UIButton) {
        let intro = IntroViewController()
        intro.showRoutinesIntro(self.view)

        
    }
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}
