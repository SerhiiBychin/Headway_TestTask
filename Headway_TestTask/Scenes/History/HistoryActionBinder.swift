//
//  HistoryActionBinder.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 02.11.2020.
//

import Foundation

final class HistoryActionBinder: ViewControllerBinder {
    unowned let viewController: HistoryViewController
    private let driver: HistoryDriving
    
    init(viewController: HistoryViewController,
         driver: HistoryDriving) {
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
            viewController.doneRightBarButton.rx.tap
                .bind(onNext: driver.close),
            
            select
                .drive(onNext: driver.select)
            
        )
    }
}
