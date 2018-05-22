//
//  UserRoutine.swift
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 10/11/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import Foundation

class UserRoutine {
    
    private var parameters = NSMutableDictionary()
    var routineNumber = [String]()
    let routineImageIdentifier = "routineImageIdentifier" //identifier to get info from plist
    let routineNumberIdentifier = "routineNumberIdentifier" //identifier to get info from plist
    let routineIdentifier = "routineIdentifier" //identifier to get info from plist
    let plistNameIdentifier = "userRoutines.plist" //identifier to plist name
    let routineIconImage = "routine"
    
    
    init(){
        if let path = path(){
            if let dict = NSMutableDictionary(contentsOfFile: path){
                parameters = dict
                let routine = getPlistString(routineNumberIdentifier)
                if routine != [] {
                    routineNumber = routine //get the previous saved data
                } else {
                    routineNumber.append("0") //start the array with zero to prevent crashes
                }
            }else{
                parameters.writeToFile(path, atomically: false)
            }
        }
    }
    
    private func path() -> String?{
        if let path: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first{
            return path.stringByAppendingPathComponent(plistNameIdentifier)
        }
        return nil
    }
    
    
    func getPlistString(identifier: String) -> [String]{
        if let routine = parameters.objectForKey(identifier) as? [String]{
            return routine
        }
        return []
    }
    
    func getPlistRoutine(identifier: String) -> [Routine] {
        if let routine = parameters.objectForKey(identifier) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(routine) as! [Routine] //get the saved routines from the plist
        }
        return [Routine(identifier: "nil", name: "nil", background: "nil", imageNames: [["nil"]])]
    }
    
    
    func setPlistString(identifier: String, routine: String) -> Bool{
        if let path = path(){
            if var routineNew = parameters.objectForKey(identifier) as? [String]{
                routineNew.append(routine) //save the new routine in the array of previous saved routines
                parameters.setObject(routineNew, forKey: identifier)
                parameters.writeToFile(path, atomically: true)
            } else {
                parameters.setObject([routine], forKey: identifier) //save a new array of routines
                parameters.writeToFile(path, atomically: true)
            }
            return true
        }
        return false
    }
    func removePlistString (identifier: String, string: String) -> Bool {
        if let path = path(){
            if var routineNew = parameters.objectForKey(identifier) as? [String]{
                for routine in routineNew {
                    if routine.containsString(string) {
                        routineNew.removeAtIndex(routineNew.indexOf(routine)!)
                    }
                }
                
                parameters.setObject(routineNew, forKey: identifier)
                parameters.writeToFile(path, atomically: true)
                return true
            }
        }
        return false
    }
    
    func setPlistRoutine(index: Int, routineName: String) -> Bool{
        if let path = path(){
            if let imagesTotal = parameters.objectForKey(routineImageIdentifier) as? [String], let number = parameters.objectForKey(routineNumberIdentifier) as? [String]{ //get the routine number and all the images saved by the user from the plist
                var routine = getPlistRoutine(routineIdentifier) // get the previous saved routines from the plist
                if routine != [] {
                    var imagesArray = [[""]]
                    var imagesForRoutine = [""]
                    var imagesOnpage = 0
                    var page = 0
                    var indexCount = 1
                    let uniqueImages = uniq(imagesTotal)
                    for string in uniqueImages {
                        
                        
                        if string.containsString("page_\(page)_number_\(number.last!)") { //check if the current image should be added to the new routine
                            let index = uniqueImages.indexOf(string) //get the position of the image in the array
                            let image = uniqueImages[index!]
                            imagesForRoutine.append(image)
                            //print (string)
                            //print(page)
                            
                            if imagesOnpage == 4 { // if the page is full save on the next page else stay on the same page
                                imagesArray.append([imagesForRoutine[indexCount]])
                                imagesOnpage = 0
                            } else {
                                imagesArray[page].append(imagesForRoutine[indexCount])
                            }
                            //print(imagesArray)
                            imagesOnpage++
                            indexCount++
                            
                            if imagesOnpage == 4 { // if the page is full save on the next page else stay on the same page
                                page++
                            }
                        }
                        
                    }
                    
                    
                    imagesArray[0].removeFirst() //remove the empty array from the first index to keep only the image names
                    let routineNew = Routine(identifier: "userRoutine" + "\(index)", name: routineName, background: routineIconImage, imageNames: imagesArray)
                    routine.append(routineNew)
                    parameters.setObject(NSKeyedArchiver.archivedDataWithRootObject(routine), forKey: routineIdentifier) //save the routine as NSData them save in the plist
                    parameters.writeToFile(path, atomically: true)
                    
                } else { //case when the user is saving the first routine on the empity plist
                    var imagesArray = [[""]]
                    var imagesForRoutine = [""]
                    var imagesOnpage = 0
                    var page = 0
                    var indexCount = 1
                    
                    for string in imagesTotal {
                        
                        if string.containsString("page_\(page)_number_\(number.last!)") { //check if the current image should be added to the new routine
                            let index = imagesTotal.indexOf(string) //get the position of the image in the array
                            let image = imagesTotal[index!]
                            imagesForRoutine.append(image)
                            //print (string)
                            //print(page)
                            
                            if imagesOnpage == 4 { // if the page is full save on the next page else stay on the same page
                                page++
                                imagesArray.append([imagesForRoutine[indexCount]])
                                imagesOnpage = 0
                            } else {
                                imagesArray[page].append(imagesForRoutine[indexCount])
                            }
                            //print(imagesArray)
                            imagesOnpage++
                            indexCount++
                        }
                        
                    }
                    
                    
                    imagesArray[0].removeFirst() //remove the empty array from the first index to keep only the image names
                    let routineNew = Routine(identifier: "userRoutine" + "\(index)", name: "userRoutine" + "\(index)", background: "AnimalGame", imageNames: imagesArray)
                    parameters.setObject(NSKeyedArchiver.archivedDataWithRootObject([routineNew]), forKey: routineIdentifier)
                    parameters.writeToFile(path, atomically: true)
                }
                return true
            }
        }
        return false
    }
    
    
}
