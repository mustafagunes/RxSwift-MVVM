//
//  AppDelegate.swift
//  RxSwift+MVVM
//
//  Created by Mustafa GUNES on 12.02.2019.
//  Copyright © 2019 Mustafa GUNES. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "home")
        
        window?.rootViewController = homeVC
        window?.makeKeyAndVisible()
        
        return true
    }
}

