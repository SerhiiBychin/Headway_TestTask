//
//  ReposStateBinder.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 28.10.2020.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class ReposStateBinder: ViewControllerBinder {    
    unowned let viewController: ReposViewController
    private let driver: ReposDriving
    private let cell = R.nib.repoTableViewCell
    
    init(viewController: ReposViewController,
         driver: ReposDriving) {
        self.viewController = viewController
        self.driver = driver
        
        bind()
    }
    
    func dispose() { }
    
    func bindLoaded() {
        viewController.tableView.register(cell)
        viewController.setDelegates()
        
        viewController.bag.insert(
            driver.state
                .drive(onNext: unowned(self, in: ReposStateBinder.apply))
        )
    }
    
    private func apply(state: ReposState) {
        switch state {
        case .loading, .none:
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        case let .results(repos):
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            viewController.setDataSource(repos)
            
        case let .searchResults(repos):
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            viewController.setDataSource(repos)
            
        case let .showWatchedRepos(repos):
            let navigationHistoryVC = UINavigationController(rootViewController: HistoryViewController.Factory.default(repos: repos))
            navigationHistoryVC.modalPresentationStyle = .formSheet
            viewController.present(navigationHistoryVC, animated: true, completion: nil)
        }
    }
    
}

extension ReposStateBinder: StaticFactory {
    enum Factory {
        static func `default`(_ viewController: ReposViewController,
                              driver: ReposDriving) -> ReposStateBinder {
            return ReposStateBinder(viewController: viewController,
                                    driver: driver)
        }
    }
}
