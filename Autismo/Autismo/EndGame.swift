//
//  EndGame.swift
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 15/09/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import SpriteKit
import AVFoundation

class EndGame: SKScene, AVAudioPlayerDelegate {
    var star1 = SKNode()
    var star2 = SKNode()
    var star3 = SKNode()
    var playNextLevel = SKNode()
    var refresh = SKNode()
    var levelSelect = SKNode()
    var audioPlayer: AVAudioPlayer?

    
    
    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateGameLevel", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopAudio:", name:"StopAudio", object: nil)

        getNodesFromScene()
        let group1 = SKAction.group([SKAction.fadeAlphaTo(1.0, duration: 1.0),SKAction.scaleBy(6.0, duration: 1.0)]) //show stars and scale to a bigger size
        let group2 = SKAction.group([SKAction.fadeAlphaTo(1.5, duration: 1.0) ,SKAction.scaleBy(6.0, duration: 1.5)])
        let group3 = SKAction.group([SKAction.fadeAlphaTo(2.0, duration: 1.0) ,SKAction.scaleBy(6.0, duration: 2.0)])
        
        playSound("cheer")
        
        star1.runAction(group1) { () -> Void in
            self.star1.runAction(SKAction.scaleBy(0.7, duration: 1.0)) //reduce the size of the star to create a spring effect
            self.playSound("StarSound")
        }
        star2.runAction(group2) { () -> Void in
            self.star2.runAction(SKAction.scaleBy(0.7, duration: 1.5))
            self.playSound("StarSound")
        }
        star3.runAction(group3) { () -> Void in
            self.star3.runAction(SKAction.scaleBy(0.7, duration: 2.0))
            self.playSound("StarSound")
        }
        playNextLevel.runAction(SKAction.fadeAlphaTo(1.0, duration: 1.0))
        refresh.runAction(SKAction.fadeAlphaTo(1.0, duration: 1.0))
        levelSelect.runAction(SKAction.fadeAlphaTo(1.0, duration: 1.0))
    }
    
    func getNodesFromScene () {
        star1 = (scene?.childNodeWithName("star1"))!
        star2 = (scene?.childNodeWithName("star2"))!
        star3 = (scene?.childNodeWithName("star3"))!
        playNextLevel = (scene?.childNodeWithName("playNextLevel"))!
        refresh = (scene?.childNodeWithName("refresh"))!
        levelSelect = (scene?.childNodeWithName("levelSelect"))!
        star1.alpha = 0 //hide stars and controls
        star2.alpha = 0
        star3.alpha = 0
        playNextLevel.alpha = 0
        refresh.alpha = 0
        levelSelect.alpha = 0
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch:UITouch = touches.first {
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)
            
            if let name = touchedNode.name
            {
                //notifications to the view controller behind the scene
                if name == "playNextLevel"
                {
                    NSNotificationCenter.defaultCenter().postNotificationName("NextLevel", object: nil)
                }
                if name == "refresh"
                {
                    NSNotificationCenter.defaultCenter().postNotificationName("RefreshGame", object: nil)
                }
                
                if name == "levelSelect"
                {
                    NSNotificationCenter.defaultCenter().postNotificationName("LevelSelect", object: nil)
                    
                }
            }
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
    
    // MARK - delegate AVAudioPlayer
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        //print("End of sound file")
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
    }

}
