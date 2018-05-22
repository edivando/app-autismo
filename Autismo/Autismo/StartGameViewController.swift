//
//  StartGameViewController.swift
//  Autismo
//
//  Created by Edivando Alves on 9/10/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import SpriteKit

var gameLevel = 0
var levelName = ""
var gameImages = [""]



class StartGameViewController: UIViewController {
    
    var game: Game?
    var levelTitle = [""]
    var levelId = 0
    var maxLevel: Int?
    var levelImages = [[""]]
    let speech = Speech()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        
//        setOrientation(.LandscapeRight)
        //get the game images and title for the level
        gameLevel = levelId
        levelName = levelTitle[gameLevel]
        gameImages = levelImages[gameLevel]
        
        // Do any additional setup after loading the view.
        //set up the notifications received from the game scenes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateGameLevel:", name:"UpdateGameLevel", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "nextLevel:", name:"NextLevel", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "levelSelect:", name:"LevelSelect", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshGame:", name:"RefreshGame", object: nil)
        
        startGame()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        setOrientation(.LandscapeRight)
    }
    
    func startGame () {
        if let scene = getScene() {
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.speech = speech
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    func getScene() -> BackgroundScene?{
        //print(game!.identifier)
        if let game = game, let gameStart = GameStart(rawValue: game.identifier){
            switch gameStart{
            case .BehaviorGame:
                return BehaviorGame(fileNamed: game.identifier)
            case .NumberGameScene:
                return NumberGameScene(fileNamed: game.identifier)
            case .SequenceGame:
                return SequenceGame(fileNamed: game.identifier)
            case .FeelingScene:
                return FeelingScene(fileNamed: game.identifier)
            case .AnimalGameScene:
                return AnimalGameScene(fileNamed: game.identifier)
            case .LandscapeGame:
                return LandscapeGame(fileNamed: game.identifier)
            case .DressingGame:
                return DressingGame(fileNamed: game.identifier)
            case .InstrumentsGame:
                return InstrumentsGameScene(fileNamed: game.identifier)
            case .MemoryGame:
                return MemoryGameScene(fileNamed: game.identifier)
            case .WordsGame:
                return WordsGameScene(fileNamed: game.identifier)
            }
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @IBAction func close(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("StopAudio", object: nil)
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func levelSelect(notification: NSNotification){
        //Take Action on Notification
        NSNotificationCenter.defaultCenter().postNotificationName("StopAudio", object: nil)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func refreshGame(notification: NSNotification){
        //Take Action on Notification
        NSNotificationCenter.defaultCenter().postNotificationName("StopAudio", object: nil)
        startGame()
    }
    
    func nextLevel(notification: NSNotification){
        //Take action on notification
        NSNotificationCenter.defaultCenter().postNotificationName("StopAudio", object: nil)
        if gameLevel < maxLevel! - 1{
            //update the game images and title for the next level
            gameLevel++
            levelName = levelTitle[gameLevel]
            gameImages = levelImages[gameLevel]
            startGame()
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func updateGameLevel(notification: NSNotification){
        NSNotificationCenter.defaultCenter().postNotificationName("StopAudio", object: nil)
//        let levelGame = LevelGame()
        if let identifier = game?.identifier{
            if let level = ProfileData.dataShared.profileSelected?.getLevel(identifier) where level <= gameLevel{  //levelGame.get(identifier)
                ProfileData.dataShared.profileSelected?.setLevel(identifier, level: level+1)     //levelGame.set(identifier, level: level+1)
                ProfileData.dataShared.updateProfile()
            }
        }
    }
    
}
