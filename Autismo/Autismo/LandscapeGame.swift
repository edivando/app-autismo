//
//  LandscapeGame.swift
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 05/10/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import SpriteKit

class LandscapeGame: BackgroundScene {
    var spriteZPosition = CGFloat(2)
    var emptySpacesObjects = [SKNode()]
    var emptySpacesObjectsPositionsPad = [[CGPoint()]]
    var emptySpacesObjectsPositionsPhone = [[CGPoint()]]
    var spriteForTutorial = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
//                        self.background.removeFromParent()
//                        background = SKSpriteNode(imageNamed: "level\(gameLevel)_background")
//                        background.name = "background"
//                        background.anchorPoint = CGPointZero
//                        background.zPosition = -1
//                        addChild(background)
        
        background.texture = SKTexture(imageNamed: "level\(gameLevel)_background")
        
        imageNames = gameImages
        remainingObjects = imageNames.count
        emptySpacesObjectsPositionsPad =
            //positions for each object in the scene for each level on the ipad
            
                // level 0
            [[CGPoint(x:  size.width / 1.2, y: size.height / 1.3 ) ,  //top right
                CGPoint(x:  size.width / 1.2, y: size.height / 1.5 - 260) , //bottom right
                CGPoint(x:  size.width / 2.2, y: size.height / 1.3 ) , //top left
                CGPoint(x:  size.width / 2.2, y: size.height / 1.5 - 260)], //bottom left
            
                // level 1
            [CGPoint(x:  size.width / 1.2, y: size.height / 1.5) , //top right
                CGPoint(x:  size.width / 1.2, y: size.height / 1.6 - 260) , //bottom right
                CGPoint(x:  size.width / 2.2, y: size.height / 1.25) , //top left
                CGPoint(x:  size.width / 2.2, y: size.height / 1.5 - 260)], //bottom left
            
                // level 2
            [CGPoint(x:  size.width / 1.2, y: size.height / 1.5 ) , //top right
                CGPoint(x:  size.width / 1.2, y: size.height / 1.7 - 260) , //bottom right
                CGPoint(x:  size.width / 2.2, y: size.height / 1.42 ) , //top left
                CGPoint(x:  size.width / 2.2, y: size.height / 1.8 - 260)] , //bottom left
            
                // level 3
            [CGPoint(x:  size.width / 2.47, y: size.height / 1.2 ) , //top left
                CGPoint(x:  size.width / 1.2, y: size.height / 1.35) , //top right
                CGPoint(x:  size.width / 2.2, y: size.height / 1.5 - 260) , //bottom left
                CGPoint(x:  size.width / 1.25, y: size.height / 1.5 - 300)], //bottom right
            
                // level 4
            [CGPoint(x:  size.width / 2.0, y: size.height / 1.23 ) , //top left
                CGPoint(x:  size.width / 1.2, y: size.height / 1.35) , //top right
                CGPoint(x:  size.width / 2.2, y: size.height / 1.5 - 270) , //bottom left
                CGPoint(x:  size.width / 1.25, y: size.height / 1.5 - 285)], //bottom right
            
                // level 5
            [CGPoint(x:  size.width / 2.0, y: size.height / 1.23 - 30 ) , //top left
                CGPoint(x:  size.width / 1.2, y: size.height / 1.35) , //top right
                CGPoint(x:  size.width / 2.2, y: size.height / 1.5 - 290) , //bottom left
                CGPoint(x:  size.width / 1.25, y: size.height / 1.5 - 285)] //bottom right 
            ]
        
        emptySpacesObjectsPositionsPhone =
            //positions for each object in the scene for each level on the iphone
            
                // level 0
            [[CGPoint(x:  size.width / 1.2, y: size.height / 1.3 - 70) ,  //top right
            CGPoint(x:  size.width / 1.2, y: size.height / 1.5 - 275) , //bottom right
            CGPoint(x:  size.width / 2.2, y: size.height / 1.3  - 70) , //top left
            CGPoint(x:  size.width / 2.2, y: size.height / 1.5 - 280)], //bottom left
            
                //level 1
            [CGPoint(x:  size.width / 1.2, y: size.height / 1.7 + 70) , //top right
                CGPoint(x:  size.width / 1.2, y: size.height / 1.88 - 210) , //bottom right
                CGPoint(x:  size.width / 2.2, y: size.height / 1.6 + 70) , //top left
                CGPoint(x:  size.width / 2.2 - 5, y: size.height / 1.8 - 205)], //bottom left
            
                //level 2
            [CGPoint(x:  size.width / 1.2, y: size.height / 1.7  + 30) , //top right
                CGPoint(x:  size.width / 1.2 + 25, y: size.height / 1.8 - 217) , //bottom right
                CGPoint(x:  size.width / 2.2, y: size.height / 1.53 + 27) , //top left
                CGPoint(x:  size.width / 2.5 - 30, y: size.height / 1.8 - 217)] , //bottom left
            
                //level 3
            [CGPoint(x:  size.width / 2.47, y: size.height / 1.4 ) , //top left
                CGPoint(x:  size.width / 1.23, y: size.height / 1.35 - 20) , //top right
                CGPoint(x:  size.width / 2.2, y: size.height / 1.5 - 260) , //bottom left
                CGPoint(x:  size.width / 1.15, y: size.height / 1.5 - 270)], //bottom right
            
                //level 4
            [CGPoint(x:  size.width / 2.47, y: size.height / 1.4 ) , //top left
                CGPoint(x:  size.width / 1.23, y: size.height / 1.35 - 10) , //top right
                CGPoint(x:  size.width / 2.2, y: size.height / 1.5 - 260) , //bottom left
                CGPoint(x:  size.width / 1.15, y: size.height / 1.5 - 270)], //bottom right
            
                //level 5
            [CGPoint(x:  size.width / 2.47, y: size.height / 1.4 ) , //top left
                CGPoint(x:  size.width / 1.23, y: size.height / 1.35 - 10) , //top right
                CGPoint(x:  size.width / 2.2, y: size.height / 1.5 - 260) , //bottom left
                CGPoint(x:  size.width / 1.15 - 20, y: size.height / 1.5 - 260)] //bottom right
            ]
        configureNodes()
    }
    
    func configureNodes () {
        // 2 add the unmovable childs
        for i in 0..<imageNames.count {
            let spriteEmpitySpace = SKSpriteNode(imageNamed: imageNames[i] + "_white")
            spriteEmpitySpace.name = "emptySpace" + imageNames[i]
            
            spriteEmpitySpace.zPosition = 1
            //spriteEmpitySpace.size = CGSize(width: size.width/9, height: size.height/7)
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                spriteEmpitySpace.size = CGSize(width: size.width/9, height: size.height/7)
                spriteEmpitySpace.xScale = 2.0
                spriteEmpitySpace.yScale = 2.0
                spriteEmpitySpace.position = emptySpacesObjectsPositionsPhone[gameLevel][i]
            } else {
                spriteEmpitySpace.position = emptySpacesObjectsPositionsPad[gameLevel][i]
            }
            emptySpacesObjects.append(spriteEmpitySpace)
            background.addChild(spriteEmpitySpace)
        }
        
        //add the movable objects
        shuffledImages = imageNames.shuffle()
        for i in 0..<imageNames.count {
            let imageName = shuffledImages[i]
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.name = shuffledImages[i]
            sprite.zPosition = spriteZPosition
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                sprite.size = CGSize(width: size.width/9, height: size.height/7)
            } else {
                sprite.xScale = 0.5
                sprite.yScale = 0.5
            }
            let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(shuffledImages.count) + 1.0)
            
            sprite.position = CGPoint(x: size.width / 8, y: size.height * offsetFraction)
            startingPositions.append(sprite.position)
            spriteObjects.append(sprite)
            background.addChild(sprite)
            let name = sprite.name
            if emptySpacesObjects[3].name!.containsString(name!) {
                spriteForTutorial = sprite
            }
        }
        if gameLevel == 0{
            
            self.addChild(self.tutorialNode)
            tutorialNode.runAction(SKAction.repeatActionForever(tutorialAction(spriteForTutorial.position, finalPosition: emptySpacesObjects[3].position)), withKey: "Tutorial")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.selectedNode.removeAllActions()
        let group = SKAction.group([SKAction.rotateToAngle(0.0, duration: 0.1) , SKAction.fadeAlphaTo(1, duration: 0.1)])
        selectedNode.runAction(group) //fix the position and alpha of the movable images
        
        var positionCount = 0
        for sprite in spriteObjects {
            for emptySpaceSprite in emptySpacesObjects {
                if emptySpaceSprite.containsPoint(sprite.position) {
                    let name = sprite.name
                    if emptySpaceSprite.name!.containsString(name!) {
                        //print("right place")
                        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                            sprite.xScale = 1
                            sprite.yScale = 1
                        }else{
                            sprite.xScale = 2
                            sprite.yScale = 2
                        }
                        isPositioning = true
                        sprite.runAction(SKAction.moveTo(CGPointMake(emptySpaceSprite.position.x, emptySpaceSprite.position.y), duration:0.5), completion: { () -> Void in
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
