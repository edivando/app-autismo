//
//  Routine.swift
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 09/11/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit

enum RoutineList: String {
    case routine1 = "routineHaircut"
    case routine2 = "routineRestroom"
}

class Routine: NSObject {
    var identifier: String = ""
    var name: String = ""
    var background: String = ""
    var imageNames: Array<Array<String>> = [[""]]

    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(identifier, forKey:"identifier")
        aCoder.encodeObject(name, forKey:"name")
        aCoder.encodeObject(background, forKey:"background")
        aCoder.encodeObject(imageNames, forKey:"imageNames")

    }
    
    init (coder aDecoder: NSCoder!) {
        self.identifier = aDecoder.decodeObjectForKey("identifier") as! String
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.background = aDecoder.decodeObjectForKey("background") as! String
        self.imageNames = aDecoder.decodeObjectForKey("imageNames") as! Array<Array<String>>
    }
    
    init(identifier: String, name: String, background: String , imageNames: Array<Array<String>>) {
        self.identifier = identifier
        self.name = name
        self.background = background
        self.imageNames = imageNames
    }
    
    static func loadRoutines() -> [Routine]{
        var routinesArray = [Routine]()
        if let json = loadJSON("routines"), let list = json["routines"] as? [Dictionary<String, AnyObject> ]{
            for routine in list{
                if let identifier = routine["identifier"] as? String, name = routine["name"] as? String, background = routine["background"] as? String, imageNames = routine["imageNames"] as? Array<Array<String>>{
                    routinesArray.append( Routine(identifier: identifier, name: name, background: background, imageNames:imageNames) )
                }
            }
        }
        return routinesArray
    }

}
