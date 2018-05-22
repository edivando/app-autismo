//
//  BehaviorGame.swift
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 14/09/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import SpriteKit

class BehaviorGame: BackgroundScene {
    
    let goodSquare = SKSpriteNode(imageNamed: "happySquare")
    let badSquare = SKSpriteNode(imageNamed: "sadSquare")
    var spriteZPosition = CGFloat(2)
    var spriteForTutorial = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        imageNames = gameImages
        remainingObjects = imageNames.count
        configureNodes()
    }
    
    
    func configureNodes () {
        goodSquare.name = "goodSquare"
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            goodSquare.position = CGPoint(x: (background.frame.width)/3.8 , y: (background.frame.height)/1.4)
            goodSquare.xScale = 0.8
            goodSquare.yScale = 0.8
        } else {
            goodSquare.position = CGPoint(x: (background.frame.width)/4 , y: (background.frame.height)/1.3)
        }
        goodSquare.zPosition = 0
        
        badSquare.name = "badSquare"
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            badSquare.position = CGPoint(x: (background.frame.width)/1.3 , y: (background.frame.height)/1.4)
            badSquare.xScale = 0.8
            badSquare.yScale = 0.8
        } else {
            badSquare.position = CGPoint(x: (background.frame.width)/1.3 , y: (background.frame.height)/1.3)
        }
        badSquare.zPosition = 0
        
        
        // 2 add the unmovable childs
        addChild(goodSquare)
        addChild(badSquare)
        
        // 3 add the movable images to the scene
        shuffledImages = imageNames.shuffle()
        for (i, _) in imageNames.enumerate(){ // i in 0..<imageNames.count {
            let imageName = shuffledImages[i]
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.name = shuffledImages[i]
            sprite.zPosition = spriteZPosition
            
            if imageNames.count > 4 {
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                    sprite.position = CGPoint(x: CGFloat(162 + Int((sprite.frame.width + 30) * CGFloat(Int(i%4)))), y: CGFloat(340 - Int((sprite.frame.height*0.8 + 4) * CGFloat(Int(i/4)))))
                    sprite.xScale = 0.8
                    sprite.yScale = 0.8
                } else {
                    sprite.position = CGPoint(x: CGFloat(162 + Int((sprite.frame.width + 30) * CGFloat(Int(i%4)))), y: CGFloat(320 - Int((sprite.frame.height + 4) * CGFloat(Int(i/4)))))
                }
            } else {
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                    sprite.xScale = 0.8
                    sprite.yScale = 0.8
                }
                let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(shuffledImages.count) + 1.0)
                sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height / 3)
            }
            startingPositions.append(sprite.position)
            spriteObjects.append(sprite)
            if sprite.name!.containsString("Good"){
                spriteForTutorial = sprite
            }
            background.addChild(sprite)
        }
        
        if gameLevel == 0{
            
            self.addChild(self.tutorialNode)
            tutorialNode.runAction(SKAction.repeatActionForever(tutorialAction(spriteForTutorial.position, finalPosition: goodSquare.position)), withKey: "Tutorial")
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.selectedNode.removeAllActions()
        let group = SKAction.group([SKAction.rotateToAngle(0.0, duration: 0.1) , SKAction.fadeAlphaTo(1, duration: 0.1)])
        selectedNode.runAction(group)
        
        
        var positionCount = 0
        for sprite in spriteObjects {
            if goodSquare.containsPoint(sprite.position) {
                if sprite.name!.containsString("Bad") {
                    //print("wrong place")
                    misplacedObjects++
                    sprite.runAction(SKAction.moveTo(startingPositions[positionCount], duration:0.5))
                    playSound("Spring")
                    
                }else {
                    //print("good square " + sprite.name!)
                    isPositioning = true
                    sprite.runAction(SKAction.moveTo(CGPointMake(goodSquare.position.x, goodSquare.position.y), duration:0.5), completion: { () -> Void in
                        self.isPositioning = false
                    })
                    playSound("GoodSound")
                    stopTutorial("Tutorial")
                    speech.stopSpeech()
                    speech.speak((sprite.name! + "Result").localized)
                    if remainingObjects > 0 {
                        remainingObjects--
                        sprite.name = "not movable"
                        spriteZPosition++
                        sprite.zPosition = spriteZPosition //put on top of all the other squares
                        startingPositions.removeAtIndex(positionCount)
                        spriteObjects.removeAtIndex(positionCount)
                        positionCount--
                    }
                }
            } else if badSquare.containsPoint(sprite.position) {
                if sprite.name!.containsString("Good") {
                    //print("wrong place")
                    misplacedObjects++
                    sprite.runAction(SKAction.moveTo(startingPositions[positionCount], duration:0.5))
                    playSound("Spring")
                    
                } else {
                    //print("bad square " + sprite.name!)
                    isPositioning = true
                    sprite.runAction(SKAction.moveTo(CGPointMake(badSquare.position.x, badSquare.position.y), duration:0.5), completion: { () -> Void in
                        self.isPositioning = false
                    })
                    playSound("GoodSound")
                    stopTutorial("Tutorial")
                    speech.stopSpeech()
                    speech.speak((sprite.name! + "Result").localized)
                    if remainingObjects > 0 {
                        remainingObjects--
                        sprite.name = "not movable"
                        spriteZPosition++
                        sprite.zPosition = spriteZPosition //put on top of all the other squares
                        startingPositions.removeAtIndex(positionCount)
                        spriteObjects.removeAtIndex(positionCount)
                        positionCount--
                    }
                }
            } else {
                //print("not inside of any squares")
                if sprite.position != startingPositions[positionCount] {
                    //only move to starting position
                    sprite.runAction(SKAction.moveTo(startingPositions[positionCount], duration:0.5))
                }
            }
            positionCount++
            //print(remainingObjects)
            selectedNode = SKSpriteNode()
        }
        if remainingObjects == 0{
            endGame()
        } else {
            spriteZPosition++
            for sprite in spriteObjects {
                //print(sprite.name, " before " , sprite.zPosition)
                sprite.zPosition = spriteZPosition //update the zPosition of all movable sprites
                //print(sprite.name, " after " , sprite.zPosition)
            }
            
        }
        
    }
}
