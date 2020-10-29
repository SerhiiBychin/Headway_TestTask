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
        let select = viewController
            .selectedIndex
            .asDriver(onError: RepoItemViewModel(id: 0, repoURL: "", name: "", imageUrl: ""))
        
        viewController.bag.insert(
            select
                .drive(onNext: driver.select)
        )
    }
}
