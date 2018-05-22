//
//  Extension.swift
//  Autismo
//
//  Created by Edivando Alves on 9/10/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import Darwin

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

extension UIImageView {
    func roundCorner(color: UIColor) -> UIImageView{
        layer.borderWidth = 5.0
        layer.borderColor = color.CGColor
        layer.cornerRadius =  frame.size.width/2.0
        clipsToBounds = true
        return self
    }
}

//MARK: Extension JSON
func loadJSON(filename: String) -> Dictionary<String, AnyObject>? {
    if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
        do{
            let data = try NSData(contentsOfFile: path, options: NSDataReadingOptions())
            let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! Dictionary<String, AnyObject>
            return dictionary
        }catch{
            //print("Could not load file: \(filename)")
            return nil

        }
    } else {
        //print("Could not find level file: \(filename)")
        return nil
    }
}

//MARK: Extension to shuffle arrays
extension CollectionType where Index == Int {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

extension String{
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    //Return an index or range from string
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    func replace(target: String, withString: String) -> String{
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
}

extension NSData {
    func saveInFile(name: String) -> Bool{
        if let path = getDocPath(){
            return self.writeToFile(path.stringByAppendingPathComponent(name), atomically: false)
        }
        return false
    }
    
    
    func image() -> UIImage?{
        return UIImage(data: self)
    }
}

extension UIColor{
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

func uniq<S: SequenceType, E: Hashable where E==S.Generator.Element>(source: S) -> [E] {
    var seen: [E:Bool] = [:]
    return source.filter({ (v) -> Bool in
        return seen.updateValue(true, forKey: v) == nil
    })
}

func getDocPath() -> NSString?{
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
}

func loadImage(name: String) -> UIImage?{
    if let path = getDocPath(){
        if fileExist(name){
            return UIImage(contentsOfFile: path.stringByAppendingPathComponent(name))
        }
    }
    return UIImage(named: "amoraIconEmptySpot")
}

func fileExist(name: String) -> Bool{
    if let path = getDocPath(){
        return NSFileManager.defaultManager().fileExistsAtPath(path.stringByAppendingPathComponent(name))
    }
    return false
}

func removeImage(name: String){
    if let path = getDocPath(){
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path.stringByAppendingPathComponent(name))
        } catch let error as NSError {
            //print(error)
        }
    }
}


extension UIImage{
    
    static func rotateCameraImageToProperOrientation(imageSource : UIImage, maxResolution : CGFloat) -> UIImage {
        
        let imgRef = imageSource.CGImage;
        
        let width = CGFloat(CGImageGetWidth(imgRef));
        let height = CGFloat(CGImageGetHeight(imgRef));
        
        var bounds = CGRectMake(0, 0, width, height)
        
        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {
//            let ratio = width/height;
            
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        
        var transform = CGAffineTransformIdentity
        let orient = imageSource.imageOrientation
        let imageSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef)), CGFloat(CGImageGetHeight(imgRef)))
        
        
        switch(imageSource.imageOrientation) {
        case .Up :
            transform = CGAffineTransformIdentity
            
        case .UpMirrored :
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            
        case .Down :
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
            
        case .DownMirrored :
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            
        case .Left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
            
        case .LeftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
            
        case .Right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
            
        case .RightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        if orient == .Right || orient == .Left {
            CGContextScaleCTM(context, -scaleRatio, scaleRatio);
            CGContextTranslateCTM(context, -height, 0);
        } else {
            CGContextScaleCTM(context, scaleRatio, -scaleRatio);
            CGContextTranslateCTM(context, 0, -height);
        }
        
        CGContextConcatCTM(context, transform);
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return imageCopy;
    }
}

//extension UIViewController{
//    func setOrientation(orientation: UIInterfaceOrientation){
//        UIDevice.currentDevice().setValue(orientation.rawValue, forKey: "orientation")
//    }
//}


