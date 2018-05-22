//
//  SequenceGame.swift
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 21/09/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import SpriteKit

class SequenceGame: BackgroundScene {
    var imagePairs = [String]()
    let horizontalBar = SKSpriteNode(imageNamed: "bar")
    var ballShapeObjects = [SKNode()]
    var spriteZPosition = CGFloat(2)
    var spriteForTutorial = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        if levelName == "paired" {
            imageNames = Array(gameImages[0..<gameImages.count/2])
            imagePairs = Array(gameImages[gameImages.count/2..<gameImages.count])
        } else {
            imageNames = gameImages
            imagePairs = [""]
        }
        remainingObjects = imageNames.count
        configureNodes()
    }
    
    
    
    func configureNodes () {
        
        horizontalBar.name = "bar"
        horizontalBar.anchorPoint = CGPointZero
        horizontalBar.position = CGPoint(x: -size.width/5, y: size.height/2.5)
        horizontalBar.zPosition = 0
        horizontalBar.xScale = 30.0
        horizontalBar.yScale = 0.1
        addChild(horizontalBar)
        
        
        // 2 add the unmovable childs
        
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            let spriteEmpityBall = SKSpriteNode(imageNamed: "ballShape")
            sprite.name = "not movable" + String(i)
            sprite.zPosition = 1
            sprite.size = CGSize(width: size.width/9, height: size.height/7)
            
            if levelName == "paired" { //put here the levels with paired images
                spriteEmpityBall.name = "ballShape" + imagePairs[i]
            } else {
                spriteEmpityBall.name = "ballShape" + imageNames[i]
            }
            
            spriteEmpityBall.zPosition = 1
            spriteEmpityBall.size = CGSize(width: size.width/9, height: size.height/7)
            
            let offsetFraction = 160.0 * (CGFloat(i)-1.0)
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                sprite.position = CGPoint(x: size.width/4 + offsetFraction , y: size.height/1.4)
                spriteEmpityBall.position = CGPoint(x: size.width/4 + offsetFraction , y: size.height/1.9)
            } else {
                sprite.position = CGPoint(x: size.width/4 + offsetFraction , y: size.height/1.2)
                spriteEmpityBall.position = CGPoint(x: size.width/4 + offsetFraction , y: size.height/1.6)
            }
            ballShapeObjects.append(spriteEmpityBall)
            background.addChild(sprite)
            background.addChild(spriteEmpityBall)
        }
        
        
        // 3 add the movable images to the scene
        if levelName == "paired" { //put here the levels with paired images
            shuffledImages = imagePairs.shuffle()
        } else {
            shuffledImages = imageNames.shuffle()
        }
        
        for i in 0..<imageNames.count {
            let imageName = shuffledImages[i]
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.name = shuffledImages[i]
            sprite.size = CGSize(width: size.width/9, height: size.height/7)
            sprite.zPosition = spriteZPosition
            
            
            let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(shuffledImages.count) + 1.0)
            
            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height / 4)
            startingPositions.append(sprite.position)
            spriteObjects.append(sprite)
            let name = sprite.name
            if ballShapeObjects[1].name!.containsString(name!) {
                spriteForTutorial = sprite
            }
            background.addChild(sprite)
        }
        
        if gameLevel == 0{
            
            self.addChild(self.tutorialNode)
            tutorialNode.runAction(SKAction.repeatActionForever(tutorialAction(spriteForTutorial.position, finalPosition: ballShapeObjects[1].position)), withKey: "Tutorial")
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.selectedNode.removeAllActions()
        let group = SKAction.group([SKAction.rotateToAngle(0.0, duration: 0.1) , SKAction.fadeAlphaTo(1, duration: 0.1)])
        selectedNode.runAction(group)  //fix the position and alpha of the movable images
        
        
        var positionCount = 0
        for sprite in spriteObjects {
            for ballShapeSprite in ballShapeObjects {
                if ballShapeSprite.containsPoint(sprite.position) {
                    let name = sprite.name
                    if ballShapeSprite.name!.containsString(name!) {
                        //print("right place")
                        
                        if levelName == "paired" {
                            speech.stopSpeech()
                            speech.speak((name! + "Result").localized) //only speak the pair when completed otherwise don't speak
                        }
                        isPositioning = true
                        sprite.runAction(SKAction.moveTo(CGPointMake(ballShapeSprite.position.x, ballShapeSprite.position.y), duration:0.5), completion: { () -> Void in
                            self.isPositioning = false
                        })
                        playSound("GoodSound")
                        stopTutorial("Tutorial")
                        
                        if remainingObjects > 0 {
                            remainingObjects--
                            sprite.name = "not movable"
                            spriteZPosition++
                            sprite.zPosition = spriteZPosition
                            startingPositions.removeAtIndex(positionCount)
                            spriteObjects.removeAtIndex(positionCount)
                            positionCount--
                        }
                        
                    } else {
                        misplacedObjects++
                        sprite.runAction(SKAction.moveTo(startingPositions[positionCount], duration:0.5))
                        playSound("Spring")
                    }
                }
            }
            if  spriteObjects.contains(sprite) {
                if sprite.position != startingPositions[positionCount] {
                    //move to starting position
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
