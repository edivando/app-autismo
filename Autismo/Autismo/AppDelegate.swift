//
//  AppDelegate.swift
//  Autismo
//
//  Created by Edivando Alves on 9/10/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override class func initialize() -> Void {
        iRate.sharedInstance().onlyPromptIfLatestVersion = false
        iRate.sharedInstance().promptForNewVersionIfUserRated = true
        iRate.sharedInstance().daysUntilPrompt = 5
        iRate.sharedInstance().usesUntilPrompt = 5
    }
    
    private func createMenuView() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let mainViewController = storyboard.instantiateViewControllerWithIdentifier("GamesCollectionViewController") as? GamesCollectionViewController,
            let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftMenuViewControllerTable") as? LeftMenuViewControllerTable{
                
            let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
            
            let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
            slideMenuController.removeRightGestures()

            self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
            self.window?.rootViewController = slideMenuController
            self.window?.makeKeyAndVisible()
        }
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

            
//        // Override point for customization after application launch.
//        
//        // [Optional] Power your app with Local Datastore. For more info, go to
//        // https://parse.com/docs/ios_guide#localdatastore/iOS
//        Parse.enableLocalDatastore()
//        
//        // Initialize Parse.
//        Parse.setApplicationId("qGGlRdS8FmhkmJ49Yp1tq9rJVwdz3vxwHFekjpKj", clientKey: "5dhWkBBSvSemF2ONzlBgLCdBRSPQzdDJlctJLkit")
//        
//        // [Optional] Track statistics around application opens.
//        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        createMenuView()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    


}

