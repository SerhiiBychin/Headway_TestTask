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
        switch state {
        case .success:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let navigationReposVC = UINavigationController(rootViewController: ReposViewController.Factory.default)
            navigationReposVC.modalPresentationStyle = .fullScreen
            viewController.present(navigationReposVC, animated: true, completion: nil)
            
        case .failure(let error):
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let actions: [UIAlertController.AlertAction] = [.action(title: "Ok", style: .destructive)]
            let errorMessage = error?.localizedDescription != "The Internet connection appears to be offline." ? "Bad credentials." : "No Internet connection."
            
            UIAlertController
                .present(in: viewController, title: "Somthing went wrong😬", message: errorMessage, style: .alert, actions: actions)
                .subscribe(onNext: { buttonIndex in
                    print(buttonIndex)
                })
                .disposed(by: bag)
            
        case .loading:
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        case .disabled:
            viewController.loginButton.isEnabled = false
            viewController.loginButton.backgroundColor = .lightGray
            
        case .enabled:
            viewController.loginButton.isEnabled = true
            viewController.loginButton.backgroundColor = .black
        }
    }
}
