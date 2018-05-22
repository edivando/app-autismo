//
//  WordsGameScene.swift
//  Autismo
//
//  Created by Flávio Tabosa on 11/10/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import SpriteKit

class WordsGameScene: BackgroundScene{
    
    var chosenWord: String!
    var lettersArray = [SKSpriteNode()]
    var initialPosition = CGPoint()
    var arrayofSquares = [SKSpriteNode()]
    var lineHeight = CGFloat()
    var spriteForTutorial = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let rand = Int(arc4random_uniform(UInt32(gameImages.count)))
        chosenWord = gameImages[rand]
        
        let imgNode = SKSpriteNode(imageNamed: chosenWord)
        chosenWord = chosenWord.localized
        background.name = "notMovable"
        imgNode.xScale = 0.65
        imgNode.yScale = 0.65
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            imgNode.position.x = self.frame.midX + imgNode.frame.width/2 - 180
            imgNode.position.y = self.frame.midY + imgNode.frame.height/4 - 50
        }else{
            imgNode.position.x = self.frame.midX + imgNode.frame.width/2 - 180
            imgNode.position.y = self.frame.midY + imgNode.frame.height/4 - 40
        }
        
        imgNode.zPosition = 1
        imgNode.name = "notMovable\(chosenWord)"
        
        addChild(imgNode)
        lettersArray.removeFirst()
        arrayofSquares.removeFirst()
        
        
        for i in 0...chosenWord.startIndex.distanceTo(chosenWord.endIndex) - 1{
            let node = SKSpriteNode(imageNamed: chosenWord[i])
            node.name = chosenWord[i]
            lettersArray.append(node)
            
        }
        spriteForTutorial = lettersArray[0]
        remainingObjects = lettersArray.count
        lettersArray.shuffleInPlace()
        for j in 0...lettersArray.count - 1{
            //ADD Letters
            let node = lettersArray[j]
            node.xScale = 0.6
            node.yScale = 0.6
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                node.position.x = 70 + (node.frame.width + 30) * CGFloat(j/4)
                node.position.y = 550 - (node.frame.height + 20) * CGFloat(j%4)
            }else{
                node.position.x = 80 + (node.frame.width + 30) * CGFloat(j/4)
                node.position.y = 620 - (node.frame.height + 20) * CGFloat(j%4)
            }
            node.zPosition = 4
            startingPositions.append(node.position)
            spriteObjects.append(node)
            addChild(node)
            
            //ADD Line
            let line = SKSpriteNode(imageNamed: "Line")
            line.xScale = 0.62
            line.yScale = 0.62
            let offset = CGFloat(j - lettersArray.count/2) * (line.frame.width + 20) + line.frame.width/2
            
            if lettersArray.count%2 == 0{
                line.position.x = imgNode.frame.midX + 10 + offset
            }else{
                line.position.x = imgNode.frame.midX - line.frame.width/2 + offset
            }
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                line.position.y = imgNode.position.y - imgNode.frame.height/2 - node.frame.height - 20
            }else{
                line.position.y = imgNode.position.y - imgNode.frame.height/2 - node.frame.height - 50
            }
            
            line.zPosition = 2
            line.name = "notMovable"
            lineHeight = line.size.height
            addChild(line)
            
            //ADD Square to move
            let square = SKSpriteNode()
            square.size.height = line.size.height + node.size.height * 2
            square.size.width = node.size.width
            square.position.x = line.position.x
            square.position.y = line.position.y
            square.alpha = 0
            square.zPosition = 3
            square.name = "notMovable"
            addChild(square)
            arrayofSquares.append(square)
        }
        
        if gameLevel == 0{
            
            self.addChild(self.tutorialNode)
            tutorialNode.runAction(SKAction.repeatActionForever(tutorialAction(spriteForTutorial.position, finalPosition: arrayofSquares[0].position)), withKey: "Tutorial")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if let touch = touches.first{
            let elapsedTime = NSDate().timeIntervalSinceDate(touchTime)
            touchTime = NSDate()
            //print("Tempo entre os toques: ", elapsedTime, " segundos")
            
            let positionInScene = touch.locationInNode(self)
            selectNodeForTouch(positionInScene)
            if !speech.isSpeaking && selectedNode.name != "notMovable"{
                speech.speak(selectedNode.name!.stringByReplacingOccurrencesOfString("notMovable", withString: ""))
            }
        }
        
    }
    
    override func selectNodeForTouch(touchLocation: CGPoint) {
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            if !selectedNode.isEqual(touchedNode) {
                //selectedNode.removeAllActions()
                if let selected = touchedNode as? SKSpriteNode{
                    selectedNode = selected
                    if let index = spriteObjects.indexOf(selected){
                        initialPosition = startingPositions[index]
                    }
                    if !touchedNode.name!.containsString("notMovable") {
                        let alphaAction = SKAction.fadeAlphaTo(0.5, duration: 0.1)
                        selectedNode.runAction(alphaAction)
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
            
            panForTranslation(translation)
            
        }
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(!selectedNode.name!.containsString("notMovable")){
            
            if let touch = touches.first{
                var moveAction = SKAction()
                var willMove = false
                var wasInside = false
                
                for square in arrayofSquares{
                    if square.containsPoint(touch.locationInNode(self)){
                        wasInside = true
                        if selectedNode.name == chosenWord[arrayofSquares.indexOf(square)!]{
                            willMove = true
                            moveAction = SKAction.moveTo(CGPoint(x: square.position.x, y: square.position.y + selectedNode.size.height/2 + lineHeight + 10), duration: 0.4)
                            remainingObjects--
                        }
                    }
                }
                var group = SKAction()
                if willMove{
                    group = SKAction.group([SKAction.fadeAlphaTo(1.0, duration: 0.1), moveAction, SKAction.runBlock({ () -> Void in
                        self.playSound("GoodSound")
                    })])
                    stopTutorial("Tutorial")
                }else{
                    let position = initialPosition
                    if wasInside{
                        group = SKAction.group([SKAction.fadeAlphaTo(1.0, duration: 0.1), SKAction.moveTo(position, duration:0.2), SKAction.runBlock({ () -> Void in
                            self.playSound("Spring")
                        })])
                        misplacedObjects++
                    }else{
                        group = SKAction.group([SKAction.fadeAlphaTo(1.0, duration: 0.1), SKAction.moveTo(position, duration:0.2)])
                    }
                }
                
                selectedNode.runAction(group, completion: { () -> Void in
                    if self.remainingObjects == 0{
                        self.speech.speak(self.chosenWord)
                        self.endGame()
                    }
                })
            }
        }
        selectedNode = SKSpriteNode()
        selectedNode.position = CGPoint(x: 0, y: 0)
        
    }
    
    
    override func panForTranslation(translation: CGPoint) {
        let position = selectedNode.position
        
        if !selectedNode.name!.containsString("notMovable"){
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        } else {
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            self.position = self.boundLayerPos(aNewPosition)
        }
    }
}
