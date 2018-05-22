//
//  Game.swift
//  Autismo
//
//  Created by Edivando Alves on 9/14/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit
import SpriteKit

enum GameStart: String {
    case BehaviorGame = "BehaviorGame"
    case NumberGameScene = "NumberGameScene"
    case SequenceGame = "SequenceGame"
    case FeelingScene = "FeelingScene"
    case AnimalGameScene = "AnimalGameScene"
    case LandscapeGame = "LandscapeGame"
    case DressingGame = "DressingGame"
    case InstrumentsGame = "InstrumentsGameScene"
    case MemoryGame = "MemoryGameScene"
    case WordsGame = "WordsGameScene"
    
    static let allValues = [BehaviorGame, NumberGameScene, SequenceGame, FeelingScene, AnimalGameScene, LandscapeGame, DressingGame, InstrumentsGame, MemoryGame, WordsGame]
    
    static let allRawValue = Set<String>([BehaviorGame.rawValue, NumberGameScene.rawValue, SequenceGame.rawValue, FeelingScene.rawValue, AnimalGameScene.rawValue, LandscapeGame.rawValue, DressingGame.rawValue, InstrumentsGame.rawValue, MemoryGame.rawValue, WordsGame.rawValue])
}

class Game: NSObject {
    
    var identifier: String = ""
    var name: String = ""
    var image: String = ""
    var levels = [String]()
    var levelImages: Array<Array<String>> = [[""]]
    
    var imageGame : UIImage?{
        return UIImage(named: image)
    }
    
    init(identifier: String, name: String, image: String, levels: [String], levelImages: Array<Array<String>>) {
        self.identifier = identifier
        self.name = name
        self.image = image
        self.levels = levels
        self.levelImages = levelImages
    }
    
    static func loadGames() -> [Game]{
        var games = [Game]()
        if let json = loadJSON("games"), let list = json["games"] as? [Dictionary<String, AnyObject> ]{
            for game in list{
                if let identifier = game["identifier"] as? String, name = game["name"] as? String, image = game["image"] as? String, levels = game["levels"] as? [String], levelImages = game["levelImages"] as? Array<Array<String>>{
                    games.append( Game(identifier: identifier, name: name, image: image, levels: levels, levelImages: levelImages) )
                }
            }
        }
        return games
    }

}
