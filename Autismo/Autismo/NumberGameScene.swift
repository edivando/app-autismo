//
//  NumberGameScene.swift
//  Autismo
//
//  Created by Flávio Tabosa on 9/14/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import SpriteKit

class NumberGameScene: BackgroundScene {
    
    //var selectedNode = SKSpriteNode()
    
    var numbersArray = NSMutableArray(objects: 0,0,0,0,0)
    
    var nodesArray = NSMutableArray()
    var chosenImageName: String!
    
    var initialPosition = CGPoint()
    var proportion : CGFloat!
    var arrayOfSelectedOperations = NSMutableArray()
    
    
    
    
    //var remainingObjects = 0
    
    
    override func didMoveToView(view: SKView) {
        
        gameNumber = 1
        
        let totalOfCountingSquares = 3
        
        proportion = (size.width/1024 + size.height/768)/2
        resetGame()
        remainingObjects = 0
        numbersArray = NSMutableArray(objects: 0,0,0,0,0)
        nodesArray = NSMutableArray()
        selectedNode.position = CGPoint(x: 0, y: 0)
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.name = "notMovable"
        self.addChild(background)
        
        let randomNumber = Int(arc4random_uniform(UInt32(gameImages.count)))
        
        
        var completionArray = [0,0,0,0,0]
        for j in 0...4 {
            if gameLevel == 0{
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                    let sqNode = SKSpriteNode(imageNamed: "quadro_contar_\(j+1)")
                    
                    sqNode.zPosition = 1
                    sqNode.size.width = 190.0 * proportion
                    sqNode.size.height = 360.0 * proportion
                    sqNode.position.x = (110.0 * proportion + (CGFloat(j) * 200.0) * proportion)
                    sqNode.position.y = 900 * proportion - sqNode.size.height - 65 * proportion
                    sqNode.name = "Square"
                    sqNode.yScale = 0.75 * proportion
                    nodesArray.addObject(sqNode)
                    self.addChild(sqNode)
                }else{
                    let sqNode = SKSpriteNode(imageNamed: "quadro_contar_\(j+1)")
                    
                    sqNode.zPosition = 1
                    sqNode.size.width = 195.0 * proportion
                    sqNode.size.height = 480.0 * proportion
                    sqNode.position.x = (110.0 * proportion + (CGFloat(j) * 200.0) * proportion)
                    sqNode.position.y = 1000 * proportion - sqNode.size.height
                    sqNode.name = "Square"
                    sqNode.yScale = 0.75 * proportion
                    nodesArray.addObject(sqNode)
                    self.addChild(sqNode)
                }
            }else if gameLevel == 1{
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                    var rand = Int(arc4random_uniform(5))
                    
                    while completionArray[rand] != 0{
                        rand = Int(arc4random_uniform(5))
                    }
                    
                    completionArray[rand] = 1
                    let sqNode = SKSpriteNode(imageNamed: "quadro_contar_\(j+1)")
                    
                    sqNode.zPosition = 1
                    sqNode.size.width = 190.0 * proportion
                    sqNode.size.height = 360.0 * proportion
                    
                    sqNode.position.x = (110.0 * proportion + (CGFloat(rand) * 200.0) * proportion)
                    sqNode.position.y = 900 * proportion - sqNode.size.height - 65 * proportion
                    sqNode.name = "Square"
                    sqNode.yScale = 0.75 * proportion
                    nodesArray.addObject(sqNode)
                    self.addChild(sqNode)
                }else{
                    var rand = Int(arc4random_uniform(5))
                    
                    while completionArray[rand] != 0{
                        rand = Int(arc4random_uniform(5))
                    }
                    
                    completionArray[rand] = 1
                    let sqNode = SKSpriteNode(imageNamed: "quadro_contar_\(j+1)")
                    
                    sqNode.zPosition = 1
                    sqNode.size.width = 195.0 * proportion
                    sqNode.size.height = 480.0 * proportion
                    sqNode.position.x = (110.0 * proportion + (CGFloat(rand) * 200.0) * proportion)
                    sqNode.position.y = 1000 * proportion - sqNode.size.height
                    sqNode.name = "Square"
                    sqNode.yScale = 0.75 * proportion
                    nodesArray.addObject(sqNode)
                    self.addChild(sqNode)
                }
            }else if gameLevel >= 2 && gameLevel <= 4{
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                    
                    let sqNode = SKSpriteNode(imageNamed: "quadro_contar_\(j+1)_\(gameLevel - 1)")
                    
                    sqNode.zPosition = 1
                    sqNode.size.width = 190.0 * proportion
                    sqNode.size.height = 360.0 * proportion
                    sqNode.position.x = (110.0 * proportion + (CGFloat(j) * 200.0) * proportion)
                    sqNode.position.y = 900 * proportion - sqNode.size.height - 65 * proportion
                    sqNode.name = "Square"
                    sqNode.yScale = 0.75 * proportion
                    arrayOfSelectedOperations.addObject(gameLevel - 1)
                    nodesArray.addObject(sqNode)
                    self.addChild(sqNode)
                }else{
                    let sqNode = SKSpriteNode(imageNamed: "quadro_contar_\(j+1)_\(gameLevel - 1)")
                    
                    sqNode.zPosition = 1
                    sqNode.size.width = 195.0 * proportion
                    sqNode.size.height = 480.0 * proportion
                    sqNode.position.x = (110.0 * proportion + (CGFloat(j) * 200.0) * proportion)
                    sqNode.position.y = 1000 * proportion - sqNode.size.height
                    sqNode.name = "Square"
                    sqNode.yScale = 0.75 * proportion
                    arrayOfSelectedOperations.addObject(gameLevel - 1)
                    nodesArray.addObject(sqNode)
                    self.addChild(sqNode)
                }
            }else if gameLevel == 5{
                let r = Int(arc4random_uniform(UInt32(totalOfCountingSquares))) + 1
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                    var rand = Int(arc4random_uniform(5))
                    
                    while completionArray[rand] != 0{
                        rand = Int(arc4random_uniform(5))
                    }
                    
                    completionArray[rand] = 1
                    let sqNode = SKSpriteNode(imageNamed: "quadro_contar_\(j+1)_\(r)")
                    
                    sqNode.zPosition = 1
                    sqNode.size.width = 190.0 * proportion
                    sqNode.size.height = 360.0 * proportion
                    
                    sqNode.position.x = (110.0 * proportion + (CGFloat(rand) * 200.0) * proportion)
                    sqNode.position.y = 900 * proportion - sqNode.size.height - 65 * proportion
                    sqNode.name = "Square"
                    sqNode.yScale = 0.75 * proportion
                    arrayOfSelectedOperations.addObject(r)
                    nodesArray.addObject(sqNode)
                    self.addChild(sqNode)
                }else{
                    var rand = Int(arc4random_uniform(5))
                    
                    while completionArray[rand] != 0{
                        rand = Int(arc4random_uniform(5))
                    }
                    
                    completionArray[rand] = 1
                    let sqNode = SKSpriteNode(imageNamed: "quadro_contar_\(j+1)_\(r)")
                    
                    sqNode.zPosition = 1
                    sqNode.size.width = 195.0 * proportion
                    sqNode.size.height = 480.0 * proportion
                    sqNode.position.x = (110.0 * proportion + (CGFloat(rand) * 200.0) * proportion)
                    sqNode.position.y = 1000 * proportion - sqNode.size.height
                    sqNode.name = "Square"
                    sqNode.yScale = 0.75 * proportion
                    arrayOfSelectedOperations.addObject(r)
                    nodesArray.addObject(sqNode)
                    self.addChild(sqNode)
                }
            }
        }
        
        
        
        for i in 0...14 {
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                let node = SKSpriteNode(imageNamed:gameImages[randomNumber])
                chosenImageName = gameImages[randomNumber]
                node.xScale = 0.4 * proportion
                node.yScale = 0.4 * proportion
                
                node.position = CGPoint(x: CGFloat(325 + Int((node.frame.width + 30) * CGFloat(Int(i%5)))) , y: CGFloat(290 - Int((node.frame.height + 5) * CGFloat(Int(i/5)))))
                node.name = "movable"
                node.zPosition = 3
                self.addChild(node)
                remainingObjects++
                spriteObjects.append(node)
                startingPositions.append(node.position)
            } else {
                let node = SKSpriteNode(imageNamed:gameImages[randomNumber])
                chosenImageName = gameImages[randomNumber]
                node.xScale = 0.48 * proportion
                node.yScale = 0.48 * proportion
                
                node.position = CGPoint(x: CGFloat(300 + Int((node.frame.width + 30) * CGFloat(Int(i%5)))) , y: CGFloat(240 - Int((node.frame.height + 5) * CGFloat(Int(i/5)))))
                node.name = "movable"
                node.zPosition = 3
                self.addChild(node)
                remainingObjects++
                spriteObjects.append(node)
                startingPositions.append(node.position)
            }
            
        }
        if gameLevel == 0{
            tutorialNode.zPosition = 20
            tutorialNode.name = "notMovable"
            tutorialNode.anchorPoint = tutorialAnchor
            self.addChild(self.tutorialNode)
            tutorialNode.runAction(SKAction.repeatActionForever(tutorialAction(spriteObjects[1].position, finalPosition: nodesArray[0].position)), withKey: "Tutorial")
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
            if !speech.isSpeaking{
                let positionInScene = touch.locationInNode(self)
                
                selectNodeForTouch(positionInScene)
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
                    if touchedNode.name == "movable" {
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

    
    override func panForTranslation(translation: CGPoint) {
        let position = selectedNode.position
        
        if selectedNode.name == "movable" {
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        } else {
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            self.position = self.boundLayerPos(aNewPosition)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(selectedNode.name == "movable"){
            var num = -1
            
            if let touch = touches.first{
                var moveAction = SKAction()
                var willMove = false
                var wasInside = false
                
                
                for index in 0 ... (nodesArray.count - 1){
                    if let number = numbersArray.objectAtIndex(index) as? Int{
                        if  nodesArray.objectAtIndex(index).containsPoint(touch.locationInNode(self)){
                            wasInside = true
                            if number <= index{
                                willMove = true
                                var newX = nodesArray.objectAtIndex(index).frame.midX
                                let newY = 40 + nodesArray.objectAtIndex(index).frame.midY - (CGFloat(Int(number/2))  * (selectedNode.frame.height + 5))
                                
                                if index % 2 == 1{
                                    if number % 2 == 0{
                                        newX = nodesArray.objectAtIndex(index).frame.midX - ((selectedNode.frame.width + 10) / 2)
                                    }else{
                                        newX = nodesArray.objectAtIndex(index).frame.midX + ((selectedNode.frame.width + 10) / 2)
                                    }
                                }else{
                                    if number != index {
                                        if number % 2 == 0{
                                            newX = nodesArray.objectAtIndex(index).frame.midX - ((selectedNode.frame.width + 10) / 2)
                                        }else{
                                            newX = nodesArray.objectAtIndex(index).frame.midX + ((selectedNode.frame.width + 10) / 2)
                                        }
                                    }
                                }
                                
                                let duration = 0.4
                                
                                moveAction = SKAction.moveTo(CGPoint(x: newX, y:newY), duration:duration)
                                
                                numbersArray.replaceObjectAtIndex(index, withObject: number + 1)
                                
                                num = index
                                
                                selectedNode.name = "notMovable"
                                remainingObjects--
                            }
                        }
                    }
                }
                var group = SKAction()
                if !willMove{
                    let position = initialPosition
                    if wasInside{
                        group = SKAction.group([SKAction.fadeAlphaTo(1.0, duration: 0.1), SKAction.moveTo(position, duration:0.2), SKAction.runBlock({ () -> Void in
                            self.playSound("Spring")
                        })])
                        misplacedObjects++
                    }else{
                        group = SKAction.group([SKAction.fadeAlphaTo(1.0, duration: 0.1), SKAction.moveTo(position, duration:0.2)])
                    }
                    
                }else{
                    group = SKAction.group([SKAction.fadeAlphaTo(1.0, duration: 0.1), moveAction, SKAction.runBlock({ () -> Void in
                        self.playSound("GoodSound")
                    })])
                    stopTutorial("Tutorial")
                    
                }
                //self.selectedNode.removeAllActions()
                if num != -1{
                    
                    if self.numbersArray.objectAtIndex(num) as! Int == num + 1 {
                        var string = self.chosenImageName.localized
                        if num + 1 > 1{
                            string = string+"s"
                        }
                        if num + 1 <= 2 && (string.hasSuffix("a") || string.hasSuffix("as") || string.hasSuffix("ã")||string.hasSuffix("ãs")){
                            let str = "\(num + 1)" + "fem"
                            var pref = ""
                            if gameLevel >= 2{
                                pref = "Count_\(num + 1)_\(arrayOfSelectedOperations.objectAtIndex(num))".localized
                            }
                            let group2 = SKAction.group([group, SKAction.runBlock({ () -> Void in
                                self.speech.speak("\(pref) \(str.localized) \(string)")
                            })])
                            selectedNode.runAction(group2, completion: { () -> Void in
                                if self.remainingObjects == 0 {
                                    self.endGame()
                                }
                            })
                            
                        }else{
                            var pref = ""
                            if gameLevel >= 2{
                                pref = "Count_\(num + 1)_\(arrayOfSelectedOperations.objectAtIndex(num))".localized
                            }
                            let group2 = SKAction.group([group, SKAction.runBlock({ () -> Void in
                                self.speech.speak("\(pref) \(num + 1) \(string)")
                            })])
                            selectedNode.runAction(group2, completion: { () -> Void in
                                if self.remainingObjects == 0 {
                                    self.endGame()
                                }
                            })
                            
                        }
                    }else{
                        selectedNode.runAction(group, completion: { () -> Void in
                            if self.remainingObjects == 0 {
                                self.endGame()
                            }
                        })
                    }
                }else{
                    selectedNode.runAction(group, completion: { () -> Void in
                        if self.remainingObjects == 0 {
                            self.endGame()
                        }
                    })
                }
                
                    
                
                
                //print("FORA")
            }
        }
        selectedNode = SKSpriteNode()
        selectedNode.position = CGPoint(x: 0, y: 0)
        
    }
    func movingAction (num: Int){
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
}