//
//  AppDelegate.swift
//  AppGuideViewController
//
//  Created by nick on 2017/8/6.
//  Copyright © 2017年 nick. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var guideViewController: AppGuideViewController?     //用户引导
    
    var rootViewController: ViewController {
        let vc = self.window!.rootViewController as! ViewController
        return vc
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //添加用户引导界面
        var coverImageNames:[UIImage] = []
        
        let imageArray : [String] = ["欢1","欢2","欢3","欢4"]
        
        // 添加背景图片
        for i in 0  ..< 4  {
           
            let image = UIImage(named: imageArray[i])
            coverImageNames.append(image!)
        }
        

        
        self.guideViewController = AppGuideViewController(images: coverImageNames,
                                                      firsBtnName: "立即体验", secondBtnName: nil,
                                                      firstBtnBg: UIColor(hex: 0x43678d), secondBtnBg: nil)
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.window!.rootViewController = self.guideViewController;
        
        self.guideViewController?.firstBtnPress = {
            () -> Void in
            self.window!.rootViewController = vc;
        }
        
        self.guideViewController?.scrollRightEdge = {
            () -> Void in
            self.guideViewController?.isLoading = false
        }
        

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

