//
//  AppCoordinator.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 26.10.2020.
//

import Foundation
import UIKit

final class AppCoordinator {
    static let shared = AppCoordinator()
    
    func startInterface(in window: UIWindow) {

        let loginController = LoginViewController.Factory.default
        
        window.rootViewController = loginController
        window.makeKeyAndVisible()
    }
}
