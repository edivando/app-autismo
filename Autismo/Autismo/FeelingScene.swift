//
//  FeelingScene.swift
//  Autismo
//
//  Created by Edivando Alves on 9/21/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import SpriteKit


class FeelingScene: BackgroundScene {
    
//    var imagesFeeling = [String]()
    let faceSprite = SKSpriteNode(imageNamed: "rosto_menino_vazio")
    let labelSprite = SKLabelNode(fontNamed: "Helvetica Neue Bold")
    
    var eyesPosition = CGPoint()
    var mouthPosition = CGPoint()
    var nosePosition = CGPoint()
    var spriteForTutorial = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        scaleMode = SKSceneScaleMode.Fill
        
        imageNames = gameImages
        shuffledImages = imageNames.shuffle()
        setRemainingObjects()
        
        faceSprite.name = "face"
        faceSprite.position = CGPointMake(700.0, 500.0)
        faceSprite.zPosition = 0.5
        background.addChild(faceSprite)
        
        labelSprite.name = levelName.localized
        labelSprite.text = levelName.localized.capitalizedString
        labelSprite.position = CGPointMake(200.0, 550.0)
        labelSprite.zPosition = 1
        labelSprite.fontSize = 60.0
        labelSprite.fontColor = UIColor.blackColor()
        background.addChild(labelSprite)
        
        eyesPosition = CGPointMake(faceSprite.position.x, 460.0)
        nosePosition = CGPointMake(faceSprite.position.x, 380.0)
        mouthPosition = CGPointMake(faceSprite.position.x, 360.0)
        
        
        for (index, img) in shuffledImages.enumerate(){
            let sprite = SKSpriteNode(imageNamed: img)
            sprite.name = img
            sprite.zPosition = 1
            
            let offsetFraction = (CGFloat(index) + 1.0)/(CGFloat(imageNames.count) + 1.0)

            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height / 5)
            
            
            spriteObjects.append(sprite)
            startingPositions.append(sprite.position)
            background.addChild(sprite)
            if sprite.name!.containsString("eyes"){
                spriteForTutorial = sprite
            }
        }
        
        
        runAction(SKAction.waitForDuration(1.0), completion: {
            self.speech.speak(levelName.localized)
        });
        
        if gameLevel == 0{
            self.addChild(self.tutorialNode)
            tutorialNode.runAction(SKAction.repeatActionForever(tutorialAction(spriteForTutorial.position, finalPosition: faceSprite.position)), withKey: "Tutorial")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.selectedNode.removeAllActions()

//        if selectedNode.name!.containsString(levelName){
            selectedNode.runAction(SKAction.group([SKAction.rotateToAngle(0.0, duration: 0.1) , SKAction.fadeAlphaTo(1, duration: 0.1)]))
//        }
        
        var aux = 0
        for sprite in spriteObjects {
            if faceSprite.containsPoint(sprite.position) {
                if let name = sprite.name{
                    if name.containsString(levelName) || name.containsString("default") {
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
//                        let group = SKAction.group([, SKAction.playSoundFileNamed("Spring.mp3", waitForCompletion: true)])
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
        if name.containsString("eyes"){
            return eyesPosition
        }else if name.containsString("nose"){
            return nosePosition
        }
        return mouthPosition
    }
    
    private func setRemainingObjects(){
        for img in imageNames{
            if img.containsString(levelName) || img.containsString("default"){
                remainingObjects++
            }
        }
    }
    
    
}
