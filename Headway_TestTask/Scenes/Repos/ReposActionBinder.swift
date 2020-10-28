//
//  ReposActionBinder.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 28.10.2020.
//

import Foundation

final class ReposActionBinder: ViewControllerBinder {
    unowned let viewController: ReposViewController
    private let driver: ReposDriving
    
    init(viewController: ReposViewController,
         driver: ReposDriving) {
        self.viewController = viewController
        self.driver = driver
        
        bind()
    }
    
    func dispose() { }
    
    func bindLoaded() {
        let viewDidLoad = viewController.rx.viewDidLoad
        //        let query = viewController.searchBar.rx.text.orEmpty
        let didSelectItem = viewController.tableView.rx.modelSelected(RepoItem.self)
                
        viewController.bag.insert(
            viewDidLoad
                .bind(onNext: driver.provideUserRepos),
//            query
//                .bind(onNext: driver.search),
            didSelectItem
                .bind(onNext: driver.select)
        )
    }
}
