//
//  BackgroundScene.swift
//  Autismo
//
//  Created by Edivando Alves on 9/23/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import SpriteKit
import AVFoundation

class BackgroundScene: SKScene, AVAudioPlayerDelegate {
    
    var background = SKSpriteNode(imageNamed: "background")
    var selectedNode = SKSpriteNode()
    var spriteObjects = [SKNode()]
    var imageNames = [String]()
    var shuffledImages = [String]()
    var startingPositions = [CGPoint()]
    var remainingObjects = 0
    var startingTime = NSDate()
    var touchTime = NSDate()
    var misplacedObjects = 0
    var speech: Speech!
    var audioPlayer: AVAudioPlayer?
    var isPositioning = false
    var gameNumber = 0
    var tutorialNode = SKSpriteNode(imageNamed: "Finger")
    var tutorialStopped = false
    let tutorialAnchor = CGPoint(x: 0.4, y: 1.0)
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        resetGame()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopAudio:", name:"StopAudio", object: nil)
        background.name = "background"
        background.anchorPoint = CGPointZero
        background.zPosition = -1
        addChild(background)
        
        
        tutorialNode.zPosition = 20
        tutorialNode.name = "notMovable"
        tutorialNode.anchorPoint = tutorialAnchor
        
        
        startingTime = NSDate()
        touchTime = startingTime
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "StopAudio", object: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !isPositioning {
        if let touch = touches.first {
            let positionInScene = touch.locationInNode(self)
            let elapsedTime = NSDate().timeIntervalSinceDate(touchTime)
            //print("Tempo entre os toques: ", elapsedTime, " segundos")
            touchTime = NSDate()
            //print("Tempo entre os toques: ", elapsedTime, " segundos")
            selectNodeForTouch(positionInScene)
        }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.locationInNode(self)
            let previousPosition = touch.previousLocationInNode(self)
            let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
            
            panForTranslation(translation)
        }
    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    func selectNodeForTouch(touchLocation: CGPoint) {
        // 1 get the touch location
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            // 2 get the touched node
            if !selectedNode.isEqual(touchedNode) {
                selectedNode.removeAllActions()
                selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: 0.1))
                
                selectedNode = touchedNode as! SKSpriteNode
                
                // 3 check if the node should be movable
                for i in 0..<imageNames.count {
                    if touchedNode.name! == shuffledImages[i] {
                        if !speech.isSpeaking {
                            speech.speak(touchedNode.name!.localized) //speek the touched node name
                        }
                        selectedNode.runAction(SKAction.fadeAlphaTo(0.5, duration: 0))
                        let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
                            SKAction.rotateByAngle(0.0, duration: 0.1),
                            SKAction.rotateByAngle(degToRad(4.0), duration: 0.1)])
                        selectedNode.runAction(SKAction.repeatActionForever(sequence))
                    }
                }
            }
        }
    }
    
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }
    
    func panForTranslation(translation: CGPoint) {
        // moving to the desired position
        let position = selectedNode.position
        for i in 0..<imageNames.count {
            if let name = selectedNode.name {
                if name == shuffledImages[i] {
                    selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
                } else {
                    let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
                    background.position = self.boundLayerPos(aNewPosition)
                }
            }
        }
    }
    
    
    func resetGame () {
        removeAllChildren()
        removeAllActions()
        background.removeAllChildren()
    }
    
    func endGame () {
        //print("game over")
        let timePlayed = NSDate().timeIntervalSinceDate(self.startingTime)
        //print("Tempo de jogo" , timePlayed, " segundos")
        //print("Objetos errados" , misplacedObjects)
        if !speech.isSpeaking {
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "presentEndGame", userInfo: nil, repeats: false)
            NSNotificationCenter.defaultCenter().postNotificationName("StopAudio", object: nil)
        } else if gameNumber == 1 && gameLevel >= 2{
            NSTimer.scheduledTimerWithTimeInterval(3.6, target: self, selector: "presentEndGame", userInfo: nil, repeats: false)
        }else{
            NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "presentEndGame", userInfo: nil, repeats: false)
        }
        
    }
    
    func presentEndGame () {
        if let endGameScene = EndGame(fileNamed: "EndGame") {
            //present the end game scene
            let reveal = SKTransition.fadeWithDuration(0.1)
            endGameScene.scaleMode = .AspectFill
            view?.presentScene(endGameScene, transition: reveal)
        }
    }
    
    func playSound(soundName: String)
    {
        let url = NSBundle.mainBundle().URLForResource(soundName , withExtension: "mp3")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL:url!)
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        }catch {
            //print("Error getting the audio file")
        }
    }

    
    func stopAudio (notification: NSNotification) {
        audioPlayer?.stop()
    }
    
    func pauseAudio () {
        audioPlayer?.pause()
    }
    
    func tutorialAction(initialPosition: CGPoint, finalPosition: CGPoint) -> SKAction{
        let action = SKAction.sequence([SKAction.runBlock({ () -> Void in
            self.tutorialNode.position = initialPosition
            
        }), SKAction.waitForDuration(0.5), SKAction.moveTo(finalPosition, duration: 1.0),SKAction.waitForDuration(1.5), SKAction.runBlock({ () -> Void in
            //self.tutorialNode.removeFromParent()
        })])
        //print(finalPosition)
        return action
    }
    
    func stopTutorial(key:String){
        if !tutorialStopped{
            self.tutorialNode.removeActionForKey(key)
            self.tutorialNode.removeFromParent()
            tutorialStopped = true
        }
    }
    
    // MARK - delegate AVAudioPlayer
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        //print("End of sound file")
        NSNotificationCenter.defaultCenter().postNotificationName("EndOfAudio", object: nil)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
    }
    
}
