//
//  LoginViewController.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 21.10.2020.
//

import UIKit

final class LoginViewController: DisposeViewController {
    @IBOutlet private (set) var usernameTextField: UITextField!
    @IBOutlet private (set) var passwordTextField: UITextField!
    @IBOutlet private (set) var loginButton: UIButton!    
}

extension LoginViewController: StaticFactory {
    enum Factory {
        static var `default`: LoginViewController {
            let loginVC = R.storyboard.main.loginViewController()!
            let driver = LoginDriver.Factory.default
            let stateBinder = LoginStateBinder(viewController: loginVC, driver: driver)
            let actionBinder = LoginActionBinder(viewController: loginVC, driver: driver)
            
            loginVC.bag.insert(stateBinder, actionBinder)
            return loginVC
        }
    }
}
