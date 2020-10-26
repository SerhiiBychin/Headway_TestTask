//
//  LoginStateBinder.swift
//  tmdb-rx-driver
//
//  Created by Dmytro Shulzhenko on 24.09.2020.
//

import UIKit

final class LoginStateBinder: ViewControllerBinder {
    private let driver: LoginDriving
    unowned let viewController: LoginViewController
    
    init(viewController: LoginViewController, driver: LoginDriving) {
        self.driver = driver
        self.viewController = viewController
        bind()
    }
    
    func dispose() { }
    
    func bindLoaded() {
        viewController.bag.insert(
            driver.state
                .drive(onNext: unowned(self, in: LoginStateBinder.applyState))
        )
    }
    
    private func applyState(_ state: LoginViewState) {
        let isLoading = state == .loading
        UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        
        let isEnabled = state != .disabled
        
        viewController.loginButton.isEnabled = isEnabled
        viewController.loginButton.backgroundColor = isEnabled ?
            UIColor.black :
            UIColor.lightGray
    }
}
