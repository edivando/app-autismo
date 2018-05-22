//
//  AnimalGameScene.swift
//  Autismo
//
//  Created by Flávio Tabosa on 9/21/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import SpriteKit

class AnimalGameScene: BackgroundScene {
    
    var initialPosition = CGPoint()
    var proportion : CGFloat!
    var isMoving = false
    var frameNode = SKSpriteNode()
    var chosenSoundName = ""
    var isPlaying = true
    var sequence: SKAction!
    var playSpeech = false
    var speechToPlay: String!
    var spriteForTutorial = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        var numberOfAnimals:UInt32  = 8
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endOfAudio:", name: "EndOfAudio", object: nil)
        
        if gameLevel <= 2{
            numberOfAnimals = 2
        }else if gameLevel <= 6{
            numberOfAnimals = 4
        }else if gameLevel <= 9{
            numberOfAnimals = 8
        }
        
        proportion = (size.width/1024 + size.height/768)/2
        
        remainingObjects = 0
        selectedNode = SKSpriteNode()
        selectedNode.position = CGPoint(x: 0, y: 0)
        selectedNode.name = "notMovable"
        
        shuffledImages = gameImages.shuffle()
        
        let randomNumber = Int(arc4random_uniform(numberOfAnimals))
        
        chosenSoundName = shuffledImages[randomNumber]
        
        
        background.name = "notMovable"
        
        
        frameNode = SKSpriteNode(imageNamed: "quadro")
        frameNode.zPosition = 1
        frameNode.position = CGPoint(x: 1024 * proportion - 209 * proportion, y: 560 * proportion - 50 - 36 * proportion)
        frameNode.size.width = 400 * proportion
        frameNode.size.height = 400 * proportion
        frameNode.name = "notMovable"
        self.addChild(frameNode)
        
        
        //CHANGE IMAGE
        let soundNode = SKSpriteNode(imageNamed: "Sound Icon")
        soundNode.zPosition = 2
        
        soundNode.yScale = 0.5 * proportion
        soundNode.xScale = 0.5 * proportion
        soundNode.anchorPoint = CGPoint(x: 1, y: 0)
        soundNode.position = CGPoint(x: frameNode.frame.maxX - 30 * proportion, y: frameNode.frame.minY - soundNode.size.height - 40 * proportion)
        soundNode.name = "Sound"
        self.addChild(soundNode)
        
        
        
        
        
        for j in 0 ... numberOfAnimals - 1 {
            let node = SKSpriteNode(imageNamed: shuffledImages[0])
            if numberOfAnimals == 8{
                
                
                node.xScale = 0.3 * proportion
                node.yScale = 0.3 * proportion
                let xPosition = Int(150 * proportion)
                let yPosition = Int(668 * proportion)
                node.position = CGPoint(x: CGFloat(xPosition + Int(CGFloat(Int(j/4)) * (node.size.width + 50))) , y: CGFloat(yPosition - 50 - Int(CGFloat(Int(j%4)) * (node.size.height + 20 * proportion))))
                node.name = shuffledImages[0]
                shuffledImages.removeFirst()
                node.zPosition = 3
                addChild(node)
                spriteObjects.append(node)
                startingPositions.append(node.position)
            }else if numberOfAnimals == 4{
                
                
                node.xScale = 0.4 * proportion
                node.yScale = 0.4 * proportion
                let xPosition = Int(150 * proportion)
                let yPosition = 530 * proportion
                node.position = CGPoint(x: CGFloat(xPosition + Int(CGFloat(Int(j/2)) * (node.size.width + 50))) , y: CGFloat(/*(self.frame.midY + node.size.height + (10))*/yPosition - CGFloat(Int(j%2)) * (node.size.height + 20 * proportion)))
                node.name = shuffledImages[0]
                shuffledImages.removeFirst()
                node.zPosition = 3
                
                addChild(node)
                spriteObjects.append(node)
                startingPositions.append(node.position)
            }else if numberOfAnimals == 2{
                
                node.xScale = 0.5 * proportion
                node.yScale = 0.5 * proportion
                
                let xPosition = Int(170 * proportion)
                node.position = CGPoint(x: CGFloat(xPosition + Int(CGFloat(Int(j)) * (node.size.width + 50))) , y: CGFloat(self.frame.midY + (20 * proportion)))
                node.name = shuffledImages[0]
                shuffledImages.removeFirst()
                node.zPosition = 3
                
                addChild(node)
                spriteObjects.append(node)
                startingPositions.append(node.position)
            }
            if node.name! == chosenSoundName{
                spriteForTutorial = node
            }
            
        }
        isPlaying = true
        let group = SKAction.sequence([SKAction.waitForDuration(1) ,SKAction.runBlock({ () -> Void in
            self.playSound(self.chosenSoundName)
        })])
        
        self.runAction(group)
        
        if gameLevel == 0{
            
            self.addChild(self.tutorialNode)
            tutorialNode.runAction(SKAction.repeatActionForever(tutorialAction(spriteForTutorial.position, finalPosition: frameNode.position)), withKey: "Tutorial")
        }
        startingTime = NSDate()
        touchTime = startingTime
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if let touch = touches.first{
            let elapsedTime = NSDate().timeIntervalSinceDate(touchTime)
            touchTime = NSDate()
            //print("Tempo entre os toques: ", elapsedTime, " segundos")
            
            let positionInScene = touch.locationInNode(self)
            
            selectNodeForTouch(positionInScene)
            
            if selectedNode.name != "notMovable" {
                if !isPlaying{
                    if selectedNode.name == "Sound" {
                        
                        isPlaying = true
                        playSpeech = false
                        sequence = SKAction.runBlock({ () -> Void in
                            self.playSound(self.chosenSoundName)
                        })
                        self.runAction(sequence)
                    
                    }else{
                        let name = selectedNode.name
                        playSpeech = true
                        isPlaying = true
                        speechToPlay = name!
                        let action1 = SKAction.runBlock({ () -> Void in
                            self.playSound(name!)
                        })
                        self.runAction(action1)
                        
                    }
                }
            }
        }
        
        
    }
    
    override func selectNodeForTouch(touchLocation: CGPoint) {
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            if !selectedNode.isEqual(touchedNode) {
                //selectedNode.removeAllActions()
                selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: 0.1))
                if let selected = touchedNode as? SKSpriteNode{
                    selectedNode = selected
                    if let index = spriteObjects.indexOf(selected){
                        initialPosition = startingPositions[index]
                    }
                    if touchedNode.name != "notMovable" && touchedNode.name != "Sound" {
                        let alphaAction = SKAction.fadeAlphaTo(0.5, duration: 0.1)
                        selectedNode.runAction(alphaAction)
                        let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
                            SKAction.rotateByAngle(0.0, duration: 0.1),
                            SKAction.rotateByAngle(degToRad(4.0), duration: 0.1)])
                        selectedNode.runAction(SKAction.repeatActionForever(sequence))
                        
                        
                    }
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let positionInScene = touch.locationInNode(self)
            let previousPosition = touch.previousLocationInNode(self)
            let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
            isMoving = true
            panForTranslation(translation)
        }
        
    }
    
    
    
    override func panForTranslation(translation: CGPoint) {
        let position = selectedNode.position
        
        if selectedNode.name != "notMovable" && selectedNode.name != "Sound" {
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        } else {
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            self.position = self.boundLayerPos(aNewPosition)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(selectedNode.name != "notMovable" && selectedNode.name != "Sound"){
            
            self.selectedNode.removeAllActions()
            let group = SKAction.group([SKAction.rotateToAngle(0.0, duration: 0.1) , SKAction.fadeAlphaTo(1, duration: 0.1)])
            
            
            selectedNode.runAction(group)  //fix the position and alpha of the movable images
            
            
            
            if let touch = touches.first{
                var moveAction = SKAction()
                var willMove = false
                var wasInside = false
                
                if frameNode.containsPoint(touch.locationInNode(self)){
                    wasInside = true
                    
                    if selectedNode.name == chosenSoundName{
                        willMove = true
                        
                        let xDist = (selectedNode.position.x - frameNode.frame.midX)
                        let yDist = (selectedNode.position.x - frameNode.frame.midY)
                        let totalDist = sqrt((xDist * xDist) + (yDist * yDist))
                        
                        let defXDist = frameNode.frame.width/2
                        let defYDist = frameNode.frame.height/2
                        let totalDefDist = sqrt((defXDist * defXDist) + (defYDist * defYDist))
                        
                        let duration = Double(0.8 * (totalDist / totalDefDist))
                        
                        moveAction = SKAction.moveTo(frameNode.position, duration:duration)
                        selectedNode.name = "notMovable"
                    }
                    
                    
                }

                var group = SKAction()
                if !willMove{
                    let position = initialPosition
                    if isMoving{
                        if wasInside{
                            group = SKAction.group([SKAction.fadeAlphaTo(1.0, duration: 0.1), SKAction.moveTo(position, duration:0.2), SKAction.playSoundFileNamed("Spring.mp3", waitForCompletion: true)])
                            misplacedObjects++
                        }else{
                            group = SKAction.group([SKAction.fadeAlphaTo(1.0, duration: 0.1), SKAction.moveTo(position, duration:0.2)])
                        }
                    }else{
                        group = SKAction.group([SKAction.fadeAlphaTo(1.0, duration: 0.1), SKAction.moveTo(position, duration:0.2)])
                    }
                    
                }else{
                    stopTutorial("Tutorial")
                    let group1 = SKAction.group([SKAction.fadeAlphaTo(1.0, duration: 0.1), moveAction, SKAction.playSoundFileNamed("GoodSound.mp3", waitForCompletion: true)])
                    group = SKAction.sequence([group1, SKAction.runBlock({ () -> Void in
                        self.endGame()
                    })])
                }
                selectedNode.runAction(group)
            }
        }
        selectedNode = SKSpriteNode()
        selectedNode.position = CGPoint(x: 0, y: 0)
        selectedNode.name = "notMovable"
        isMoving = false
        
    }
    
    func endOfAudio(notification: NSNotification) {
        
        if playSpeech{
            let gr = SKAction.group([SKAction.runBlock({ () -> Void in
                self.speech.speak(self.speechToPlay.localized)
            }), SKAction.waitForDuration(1)])
            self.runAction(gr, completion: { () -> Void in
                self.isPlaying = false
            })
            
        }else{
            isPlaying = false
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
}