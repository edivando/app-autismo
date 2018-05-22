//
//  WearGameScene.swift
//  Autismo
//
//  Created by Edivando Alves on 10/19/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import SpriteKit


class DressingGame: BackgroundScene {
    
    var pessoaImage = "menina"
    var pessoaSprite = SKSpriteNode()
    var scaleAdpter: CGFloat = 1.0
    let labelSprite = SKLabelNode(fontNamed: "Helvetica Neue Bold")
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        scaleMode = SKSceneScaleMode.Fill
        
        pessoaImage = levelName.containsString("menina") ? "menina" : "menino"
        pessoaSprite = SKSpriteNode(imageNamed: pessoaImage)
        
        labelSprite.name = levelName.localized
        labelSprite.text = levelName.localized.capitalizedString
        labelSprite.position = CGPointMake(195.0, 650.0)
        labelSprite.zPosition = 1
        labelSprite.fontSize = 40.0
        if gameLevel == 1 || gameLevel == 2{
            labelSprite.fontSize = 35
        }
        labelSprite.fontColor = UIColor.blackColor()
        background.addChild(labelSprite)
        
        imageNames = gameImages
        shuffledImages = imageNames.shuffle()
        setRemainingObjects()

        pessoaSprite.name = "face"
        pessoaSprite.position = CGPointMake(700.0, 400.0)
        pessoaSprite.zPosition = 0.5
        pessoaSprite.yScale = scaleAdpter
        background.addChild(pessoaSprite)
        
        background.texture = SKTexture(imageNamed: "vestir_background")
        
        for (index, img) in shuffledImages.enumerate(){
            let sprite = SKSpriteNode(imageNamed: img)
            sprite.name = img
            sprite.zPosition = 1
            sprite.anchorPoint.y = 1
            sprite.anchorPoint.x = 0.5
            sprite.yScale = scaleAdpter
            
            let offsetFraction = (CGFloat(index) + 1.0)/(CGFloat(imageNames.count) + 1.0)
            
            sprite.position = CGPoint(x: size.width / 5, y: size.height * offsetFraction)
            
            spriteObjects.append(sprite)
            startingPositions.append(sprite.position)
            background.addChild(sprite)
        }
        
        runAction(SKAction.waitForDuration(1.0), completion: {
            self.speech.speak(levelName.localized)
        });
        
        if gameLevel == 0{
            
            self.addChild(self.tutorialNode)
            tutorialNode.runAction(SKAction.repeatActionForever(tutorialAction(spriteObjects[1].position, finalPosition: pessoaSprite.position)), withKey: "Tutorial")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.selectedNode.removeAllActions()

        if let name = selectedNode.name{
            if name.containsString(pessoaImage){
                selectedNode.runAction(SKAction.group([SKAction.rotateToAngle(0.0, duration: 0.1) , SKAction.fadeAlphaTo(1, duration: 0.1)]))
            }
        }

        var aux = 0
        for sprite in spriteObjects {
            //print(sprite.position)
            if pessoaSprite.containsPoint(sprite.position) {
                if let name = sprite.name{
                    if name.containsString(pessoaImage) {
                        playSound("GoodSound")
                        stopTutorial("Tutorial")
                        isPositioning = true
                        sprite.runAction(SKAction.moveTo(getPositionByFaceItem(name), duration:0.5), completion: { () -> Void in
                            self.isPositioning = false
                        })
                        if remainingObjects > 0 {
                            remainingObjects--
                            sprite.name = "not movable"
                            startingPositions.removeAtIndex(aux)
                            spriteObjects.removeAtIndex(aux)
                            aux--
                        }
                    }else{
                        misplacedObjects++
                        playSound("Spring")
                        sprite.runAction(SKAction.moveTo(startingPositions[aux], duration:0.5))
                        
                    }
                }
            }
            
            if  spriteObjects.contains(sprite) {
                if sprite.position != startingPositions[aux] {
//                    playSound("Spring")
                    sprite.runAction(SKAction.moveTo(startingPositions[aux], duration:0.5))
                }
            }
            
            sprite.alpha = 1.0
            aux++
            selectedNode = SKSpriteNode()
        }
        
        if remainingObjects == 0{
            endGame()
        }
    }
    
    private func getPositionByFaceItem(name: String) -> CGPoint{
        var position = CGPointMake(pessoaSprite.position.x, 430.0)
        if name == "menina_vestido_1"{
            position.x = position.x - 5.0
        }else if name == "menina_saia_1"{
            position.y = 280.0
            position.x = position.x - 10.0
        }else if name == "menina_blusa_1"{
            position.x = position.x - 10.0
        }else if name == "menina_maio"{
            position.x = position.x - 14.0
            position.y = 425.0
        }else if name == "menina_saia_2"{
            position.y = 280.0
            position.x = position.x - 12.0
        }else if name == "menina_blusa_2"{
            position.y = 425.0
            position.x = position.x - 8.0
        }else if name == "menino_calca_1"{
            position.y = 265.0
            position.x = position.x - 10.0
        }else if name == "menino_blusa_1"{
            position.y = 436.0
            position.x = position.x - 5.0
        }else if name == "menino_calca_2"{
            position.y = 274.0
            position.x = position.x - 10.0
        }else if name == "menino_blusa_2"{
            position.y = 435.0
            position.x = position.x - 3.0
        }else if name == "menino_calca_3"{
            position.y = 270.0
            position.x = position.x - 10.0
        }else if name == "menino_blusa_3"{
            position.y = 436.0
            position.x = position.x - 3.0
        }
        return position
    }
    
    private func setRemainingObjects(){
        for img in imageNames{
            if img.containsString(pessoaImage){
                remainingObjects++
            }
        }
    }
    
}

