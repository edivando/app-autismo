//
//  MemoryGameScene.swift
//  Autismo
//
//  Created by Flávio Tabosa on 11/4/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import SpriteKit

class MemoryGameScene : BackgroundScene {
    
    var proportion : CGFloat!
    var texturesArray = [SKTexture()]
    var soundsArray = [String()]
    var sequenceArray = ["0"]
    var groupActions = [SKAction()]
    var allowClicks = false
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        texturesArray.removeFirst()
        soundsArray.removeFirst()
        spriteObjects.removeFirst()
        groupActions.removeFirst()
        proportion = (size.width/1024 + size.height/768)/2
        
        remainingObjects = 0
        selectedNode = SKSpriteNode()
        selectedNode.position = CGPoint(x: 0, y: 0)
        selectedNode.name = "notClickable"
        
        background.name = "notClickable"
        
        sequenceArray = gameImages
        
        for i in 0...3{
            let sound = "MemoryGameSound\(i)"
            soundsArray.append(sound)
        }
        
        
        for j in 0...3{
            let texture = SKTexture(imageNamed: "DarkPiece\(j)")
            texturesArray.append(texture)
        }
        
        for k in 0...3{
            let texture = SKTexture(imageNamed: "LightPiece\(k)")
            texturesArray.append(texture)
        }
        
        let esboc = SKSpriteNode(texture: SKTexture(imageNamed: "fundo_JogoDaMemoria"))
        esboc.position.x = self.frame.midX
        esboc.position.y = self.frame.midY
        esboc.zPosition = 1
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            esboc.xScale = 0.75
            esboc.yScale = 0.75
        }
        addChild(esboc)
        
        groupActions.append(SKAction.waitForDuration(1.0))
        for l in 0...sequenceArray.count - 1{
            if let ind = Int(sequenceArray[l]){
                let action = SKAction.group([actionGlowLight(ind), SKAction.waitForDuration(0.7)])
                groupActions.append(action)
            }
        }
        
        
        
        for m in 0...3 {
            let node = SKSpriteNode(texture: texturesArray[m])
            let offsetX = CGFloat(m % 2) * esboc.frame.width/2
            let offsetY = CGFloat(m / 2) * esboc.frame.height/2
            node.position.x = esboc.frame.midX - esboc.frame.width/4 + offsetX
            node.position.y = esboc.frame.midY + esboc.frame.height/4 - offsetY
            node.zPosition = 2
            node.name = "\(m)"
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                node.xScale = 0.7
                node.yScale = 0.7
            }
            addChild(node)
            spriteObjects.append(node)
        }
        
        let sequence = SKAction.sequence(groupActions)
        self.runAction(sequence, completion: { () -> Void in
            self.allowClicks = true
        })

        startingTime = NSDate()
        touchTime = startingTime
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let elapsedTime = NSDate().timeIntervalSinceDate(touchTime)
            //print("Tempo entre os toques: ", elapsedTime, " segundos")
            touchTime = NSDate()
            let positionInScene = touch.locationInNode(self)
            let node = self.nodeAtPoint(positionInScene)
            if allowClicks{
                if node.name != "notClickable"{
                    if node.name == sequenceArray.first{
                        if let ind = Int(node.name!){
                            sequenceArray.removeFirst()
                            self.runAction(actionGlowLight(ind), completion: { () -> Void in
                                if self.sequenceArray.isEmpty{
                                    self.endGame()
                                }
                            })
                        }
                    }else{
                        misplacedObjects++
                    }
                }
            }
        }
    }
    
    
    
    func actionGlowLight(index: Int) -> SKAction{
        
        let group = SKAction.group([SKAction.runBlock({ () -> Void in
            if let node = self.spriteObjects[index] as? SKSpriteNode{
                node.texture = self.texturesArray[index + 4]
            }
        }), SKAction.playSoundFileNamed(self.soundsArray[index], waitForCompletion: false), SKAction.waitForDuration(0.5) ])
        
        
        
        let action = SKAction.sequence([group, SKAction.runBlock({ () -> Void in
            if let node = self.spriteObjects[index] as? SKSpriteNode{
                node.texture = self.texturesArray[index]
            }
        })])
        
        return action
    }
}