//
//  AppDelegate.swift
//  Todoey
//
//  Created by Jamal Simmonds on 10/10/18.
//  Copyright © 2018 Jamal Simmonds. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        do{
            _ = try Realm()
        }catch  {
            print("Error initializing realm\(error)")
        }
        
        return true
    }
    

    
}




