//
//  ProfileData.swift
//  Autismo
//
//  Created by Edivando Alves on 11/10/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import Foundation

private let _ProfileDataInstance = ProfileData()

class ProfileData: NSObject {
    
    //MARK: Singleton WebSocket
    class var dataShared: ProfileData {
        return _ProfileDataInstance
    }
    
    private var parameters = NSMutableDictionary()
    
    var profileSelected: Profile?
    
    private override init(){
        super.init()
        if let path = self.path(){
            //print(path)
            if let dict = NSMutableDictionary(contentsOfFile: path){
                parameters = dict
            }else{
                parameters.writeToFile(path, atomically: false)
            }
        }
    }
    
    private func path() -> String?{
        if let path: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first{
            return path.stringByAppendingPathComponent("profile.plist")
        }
        return nil
    }
    
    func get(id: Int) -> Profile?{
        if let profile = parameters.objectForKey(id) as? Profile{
            return profile
        }
        return nil
    }
    
    func set(id: String, profile: Profile) -> Bool{
        if let path = path(){
            parameters.setObject(profile.toArray(), forKey: id)
            parameters.writeToFile(path, atomically: true)
            return true
        }
        return false
    }
    
    func save(profile: Profile){
        if let id = profile.id{
            set(id, profile: profile)
        }
    }
    
    func remove(profile: Profile) -> Bool{
        if let path = path(), let id = profile.id{
            parameters.removeObjectForKey(id)
            parameters.writeToFile(path, atomically: true)
            removeImage("\(id).png")
            return true
        }
        return false
    }
    
    func updateProfile(){
        if let profile = profileSelected{
            save(profile)
        }
    }
    
    func values() -> [Profile]{
        var profiles = [Profile]()
        if let values = parameters.allValues as? [NSArray]{
            for value in values{
                profiles.append(Profile.toProfile(value))
            }
        }
        return profiles
    }
    
    var count: Int{
        return values().count
    }
    
    var nextId: Int{
        return count+1
    }
    
    func getProfileSelected() -> Profile?{
        if self.profileSelected == nil{
            self.profileSelected = values().first
        }
        return self.profileSelected
    }
    
}


class Profile: NSObject{
    var id: String?
    var name: String?
    var games = Set<String>()
    var levels = [String: Int]()
    
    override init() {
        super.init()
    }
    
    init(id: String, name: String, games: Set<String>, levels: [String: Int]) {
        self.id = id
        self.name = name
        self.games = games
        self.levels = levels
    }
    
    func new() -> Profile{
        id = NSDate().timeIntervalSince1970.description //ProfileData.dataShared.nextId
        name = ""
        games = GameStart.allRawValue
        return self
    }
    
    func getImage() -> UIImage?{
        if let id = id{
            return loadImage("\(id).png")
        }
        return nil
    }   
    
    func setImage(image: UIImage){
        //print("\(id).png")
        if let id = id{
            UIImagePNGRepresentation(image)?.saveInFile("\(id).png")
        }
    }
    
    func updateGame(game: String){
        if isGame(game){
            games.remove(game)
            levels.removeValueForKey(game)
        }else{
            games.insert(game)
            levels[game] = 0
        }
    }
    
    func isGame(game: String) -> Bool{
        for g in games{
            if g == game{
                return true
            }
        }
        return false
    }
    
    
    func getLevel(gameStart: GameStart) -> Int{
        return getLevel(gameStart.rawValue)
    }
    
    func getLevel(identifier: String) -> Int{
        if let level = levels[identifier]{
            return level
        }
        return 0
    }
    
//    func setLevel(gameStart: GameStart, level: Int) -> Bool{
//        return setLevel(gameStart.rawValue, level: level)
//    }
    
    func setLevel(identifier: String, level: Int){
        levels[identifier] = level
    }
    
    
    
    
    
    
    func toArray() -> NSArray{
        return [id!, name!, Array(games), levels]
    }
    
    static func toProfile(data: NSArray) -> Profile{
        if let id = data[0] as? String, name = data[1] as? String, games = data[2] as? [String], levels = data[3] as? [String: Int] {
            //print(games)
//            let g = games.replace("[", withString: "").replace("]", withString: "").replace("\"", withString: "").characters.split{$0 == ","}.map(String.init)
            return Profile(id: id, name: name, games: Set(games), levels: levels)
        }
        return Profile()
    }
    
}
