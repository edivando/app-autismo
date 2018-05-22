//
//  ProfileViewController.swift
//  Autismo
//
//  Created by Edivando Alves on 10/27/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit

class ProfileViewController: UICollectionViewController, GMImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
//    @IBOutlet var userImage: UIImageView!
//    @IBOutlet var userName: UITextField!
    
    var imagePicker = GMImagePickerController()
    var games = [Game]()
    
    var viewHeader:ProfileReusableView?
    
    var profile = Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.games = Game.loadGames()
    }
    
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? ProfileCollectionViewCell{
            let game = games[indexPath.row]
            cell.imageGame.image = game.imageGame
            cell.imageStatus.image = UIImage(named: profile.isGame(game.name) ? "icon_remove" : "icon_add")
            
            //print(game.image)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            if let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "sectionHeader", forIndexPath: indexPath) as? ProfileReusableView{
                
                view.image.layer.cornerRadius = view.image.frame.width / 2.0
                view.image.clipsToBounds = true
                view.image.layer.borderWidth = 3.0
                view.image.layer.borderColor = UIColor(red: 102, green: 179, blue: 244).CGColor  ////102 179 224
                view.image.image = profile.getImage()
                view.name.placeholder = "Seu nome"
                view.name.text = profile.name
//                view.image.contentMode = .ScaleAspectFit
                
                let singleTap = UITapGestureRecognizer(target: self, action: "editImage:")
                singleTap.numberOfTapsRequired = 1
                singleTap.numberOfTouchesRequired = 1
                view.image.addGestureRecognizer(singleTap)
                view.image.userInteractionEnabled = true
                
                viewHeader = view
                return view
            }
            
        }
        return UICollectionReusableView()
    }
    
    
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        profile.updateGame(games[indexPath.row].name)
        ProfileData.dataShared.save(profile)
        collectionView.reloadItemsAtIndexPaths([indexPath])
//        collectionView.reloadData()
    }


    func editImage(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.Ended){
            imagePicker = GMImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.title = "Gallery".localized
            imagePicker.customNavigationBarPrompt = "Pick a picute".localized
            imagePicker.colsInPortrait = 3
            imagePicker.colsInLandscape = 5
            imagePicker.minimumInteritemSpacing = 2.0
            
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        imagePicker.dismissViewControllerAnimated(true, completion: nil)
//        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
//            if let view = viewHeader{
//                view.image.image = image
//            }
//            profile.setImage(image)
//        }
//    }
    
    func assetsPickerController(picker: GMImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        if let info = assets{
            if let asset = info[0] as? PHAsset{
                let image = getAssetThumbnail(asset)
                if let view = viewHeader{
                    view.image.image = image
                }
                UIImagePNGRepresentation(image)?.saveInFile("\(profile.id).png")
                profile.setImage(image)
            }
            //print(info[0])
        }
        
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func assetsPickerControllerDidCancel(picker: GMImagePickerController!) {
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFill, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }

    
    @IBAction func save(sender: AnyObject) {
        if let view = viewHeader{
            profile.name = view.name.text
            ProfileData.dataShared.save(profile)
            ProfileData.dataShared.profileSelected = profile
            dismissViewControllerAnimated(true, completion: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("RefreshGames", object: nil)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func removeProfile(sender: AnyObject) {
        ProfileData.dataShared.remove(profile)
    }
}
