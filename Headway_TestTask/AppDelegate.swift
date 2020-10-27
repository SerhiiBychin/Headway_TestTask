//
//  AppDelegate.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 21.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            AppCoordinator.shared.startInterface(in: window)
        }
        
        return true
    }
}

