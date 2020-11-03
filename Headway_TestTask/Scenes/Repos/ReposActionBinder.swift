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
        
        let watchedRepos = viewController
            .selectedIndexes
            .asDriver(onError: [RepoItemViewModel(id: 0, repoURL: "", name: "", imageUrl: "")])
        
        let query = viewController.searchBar.rx.text.orEmpty
        
        viewController.bag.insert(
            select
                .drive(onNext: driver.select),
            
            watchedRepos
                .drive(onNext: driver.save),
            
            query
                .bind(onNext: driver.search),
            
            viewController.historyRightBarButton.rx.tap
                .bind(onNext: driver.showWatchedRepos)
        )
    }
}
