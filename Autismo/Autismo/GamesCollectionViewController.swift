//
//  GamesCollectionViewController.swift
//  Autismo
//
//  Created by Edivando Alves on 9/10/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse
import SpriteKit

let reuseIdentifier = "cellGame"

class GamesCollectionViewController: UICollectionViewController {

    var games = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        
        if ProfileData.dataShared.count == 0{
            if fileExist("autismo.plist"){          // Update new version
                let levelGame = LevelGame()
                let profile = Profile().new()
                profile.name = levelGame.getName()
                for game in GameStart.allValues{
                    //print(game.rawValue)
                    profile.games.insert(game.rawValue)
                    profile.setLevel(game.rawValue, level: levelGame.get(game))
                }
                
                if let image = loadImage("img.png"){
                    profile.setImage(image)
                }
                
                ProfileData.dataShared.save(profile)
                ProfileData.dataShared.profileSelected = profile
                
            }else{                                  // New instalation
                NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "openModal", userInfo: nil, repeats: false)
            }
        }

        self.games = Game.loadGames()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshGames:", name:"RefreshGames", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showIntroMain:", name:"IntroMain", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        games = [Game]()
        if let profile = ProfileData.dataShared.getProfileSelected(){
            for pGame in profile.games{
                for game in Game.loadGames(){
                    //print("\(pGame) == \(game.identifier)")
                    if pGame == game.identifier{
                        games.append(game)
                    }
                }
            }
        }else{
            self.games = Game.loadGames()
        }
        collectionView?.reloadData()
    }
    
    func refreshGames(notification: NSNotification){
        games = [Game]()
        if let profileGames = ProfileData.dataShared.getProfileSelected()?.games{
            for pGame in profileGames{
                for game in Game.loadGames(){
                    if pGame == game.name{
                        games.append(game)
                    }
                }
            }
        }
        collectionView?.reloadData()
    }
    
    func showIntroMain(notification: NSNotification){
        let intro = IntroViewController()
        intro.showMainIntro(self.view)
    }

    
//    func openModal(recognizer: UILongPressGestureRecognizer) {
//        performSegueWithIdentifier("profileSegue", sender: nil)
//    }
    
    func openModal(){
//        openLeft()
        performSegueWithIdentifier("segueFirstProfile", sender: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }

    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeLeft
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GameCollectionViewCell
        cell.imageGame.image = games[indexPath.row].imageGame
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            if let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "sectionHeader", forIndexPath: indexPath) as? GameHeaderCollectionReusableView{
                
                let tap = UILongPressGestureRecognizer(target: self, action: "openMenu")
                tap.minimumPressDuration = 1.0
                view.image.addGestureRecognizer(tap)
            
//                view.image.setImage(loadImage("img.png"), forState: .Normal)
                view.image.layer.borderWidth = 3.0
                view.image.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor  ////102 179 224
                view.image.layer.cornerRadius =  view.image.frame.size.height/2
                view.image.clipsToBounds = true
                
                let profile = ProfileData.dataShared.profileSelected
                
                view.name.text = profile?.name
                view.image.setImage(profile?.getImage(), forState: .Normal)
                return view
            }
            
        }
        return UICollectionReusableView()
    }
    
    func openMenu(){
        openLeft()
//        performSegueWithIdentifier("segueFirstProfile", sender: nil)
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("segueLevel", sender: games[indexPath.row])
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueLevel" && segue.destinationViewController.isKindOfClass(LevelGameViewController.classForCoder()) {
            if let controller = segue.destinationViewController as? LevelGameViewController, let game = sender as? Game{
                controller.game = game
            }
        }
    }
    
    // MARK: - UICollectionViewFlowLayout    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }


}
