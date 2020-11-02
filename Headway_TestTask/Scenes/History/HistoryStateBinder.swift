//
//  HistoryStateBinder.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 02.11.2020.
//

import Foundation

final class HistoryStateBinder: ViewControllerBinder {
    unowned let viewController: HistoryViewController
    private let driver: HistoryDriver
    
    init(viewController: HistoryViewController,
         driver: HistoryDriver) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }
    
    func dispose() {}
    
    func bindLoaded() {
        viewController.bag.insert(
            driver.data
                .drive(onNext: unowned(self, in: HistoryStateBinder.configure))
        )
    }
    
    private func configure(_ repos: [RepoItemViewModel]) {

    }
}
