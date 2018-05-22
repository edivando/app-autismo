//
//  LevelGame.swift
//  Autismo
//
//  Created by Edivando Alves on 10/20/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import Foundation

class LevelGame {
    
    private var parameters = NSMutableDictionary()
    
    init(){
//        parameters.setObject("Maria Flavia", forKey: "NAME")
//        parameters.setObject(GameStart.MemoryGame.rawValue, forKey: 2)
//        parameters.setObject(GameStart.AnimalGameScene.rawValue, forKey: 3)
//        parameters.setObject(GameStart.DressingGame.rawValue, forKey: 1)
//        parameters.setObject(GameStart.FeelingScene.rawValue, forKey: 5)
//        parameters.setObject(GameStart.LandscapeGame.rawValue, forKey: 4)
//        parameters.setObject(GameStart.NumberGameScene.rawValue, forKey: 1)
        
        if let path = path(){
            if let dict = NSMutableDictionary(contentsOfFile: path){
                parameters = dict
            }else{
                parameters.writeToFile(path, atomically: false)
            }
        }
    }
    
    private func path() -> String?{
        if let path: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first{
            return path.stringByAppendingPathComponent("autismo.plist")
        }
        return nil
    }
    
    func get(gameStart: GameStart) -> Int{
        return get(gameStart.rawValue)
    }
    
    func get(identifier: String) -> Int{
        if let level = parameters.objectForKey(identifier) as? Int{
            return level
        }
        return 0
    }
    
    func set(gameStart: GameStart, level: Int) -> Bool{
        return set(gameStart.rawValue, level: level)
    }
    
    func set(identifier: String, level: Int) -> Bool{
        if let path = path(){
            parameters.setObject(level, forKey: identifier)
            parameters.writeToFile(path, atomically: false)
            return true
        }
        return false
    }
    
    func setName(name: String) -> Bool{
        if let path = path(){
            parameters.setObject(name, forKey: "NAME")
            parameters.writeToFile(path, atomically: false)
            return true
        }
        return false
    }
    
    func getName() -> String{
        if let name = parameters.objectForKey("NAME") as? String{
            return name
        }
        return "name_ola".localized
    }
    
    func openModalImage() -> Bool{
        if let _ = parameters.objectForKey("OPEN_MODAL") as? String{
            return false
        }else{
            if let path = path(){
                parameters.setObject("OPEN_MODAL", forKey: "OPEN_MODAL")
                parameters.writeToFile(path, atomically: false)
            }
            return true
        }
    }
}
