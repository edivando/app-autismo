//
//  LevelGameViewController.swift
//  Autismo
//
//  Created by Edivando Alves on 9/16/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit
import SpriteKit


class LevelGameViewController: UICollectionViewController {
    
    var game: Game?
    var imageLevels = ["1", "2", "3", "4" , "5", "6", "7", "8", "9", "10"]
    var levelLiberado = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
//        setOrientation(.LandscapeRight)
        
        if let identifier = game?.identifier, level = ProfileData.dataShared.profileSelected?.getLevel(identifier){
            levelLiberado = level   //LevelGame().get(identifier)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        setOrientation(.LandscapeRight)
        if let identifier = game?.identifier, level = ProfileData.dataShared.profileSelected?.getLevel(identifier){
            levelLiberado = level   //LevelGame().get(identifier)
        }
        
//        if let identifier = game?.identifier{
//            levelLiberado = LevelGame().get(identifier)
//        }
        collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (game?.levels.count)!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellLevel", forIndexPath: indexPath) as! LevelCollectionViewCell
        if indexPath.row == levelLiberado{
            cell.imageLevel.image = UIImage(named: "liberado_nivel_\(indexPath.row+1)")  //       imageLevels[indexPath.row])
        }else if indexPath.row < levelLiberado{
            cell.imageLevel.image = UIImage(named: "conluido_nivel_\(indexPath.row+1)")
        }else{
            cell.imageLevel.image = UIImage(named: "bloqueado_nivel_\(indexPath.row+1)")
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "sectionLevelHeader", forIndexPath: indexPath)
            return view
        }
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "sectionLevelFooter", forIndexPath: indexPath)
        return view
    }
    
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row <= levelLiberado{
            performSegueWithIdentifier("segueStartGame", sender: indexPath.row)
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueStartGame" && segue.destinationViewController.isKindOfClass(StartGameViewController.classForCoder()) {
            if let controller = segue.destinationViewController as? StartGameViewController, let rowId = sender as? Int{
                controller.game = game
                controller.levelTitle = (game?.levels)!
                controller.levelId = rowId
                controller.levelImages = game!.levelImages
                controller.maxLevel = game?.levels.count
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
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}
