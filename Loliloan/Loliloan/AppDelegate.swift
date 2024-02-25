//
//  AppDelegate.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 24/02/24.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let nc = UINavigationController(rootViewController: LoanListVC())
        nc.navigationBar.tintColor = .orangered
        window.rootViewController = nc
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
}

