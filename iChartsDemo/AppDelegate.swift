//
//  AppDelegate.swift
//  iChartsDemo
//
//  Created by Volodymyr Hryhoriev on 3/11/19.
//  Copyright © 2019 Volodymyr Hryhoriev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        configureWindow()
        return true
    }
    
    func configureWindow() {
        window = UIWindow()
        let vc = ViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

