//
//  HistoryStateBinder.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 02.11.2020.
//

import Foundation

final class HistoryStateBinder: ViewControllerBinder {
    unowned let viewController: HistoryViewController
    private let driver: HistoryDriving
    private let cell = R.nib.repoTableViewCell
    
    init(viewController: HistoryViewController,
         driver: HistoryDriving) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }
    
    func dispose() {}
    
    func bindLoaded() {
        viewController.tableView.register(cell)
        viewController.setDelegates()

        viewController.bag.insert(
            driver.data
                .drive(onNext: unowned(self, in: HistoryStateBinder.configure))
        )
    }
    
    private func configure(_ repos: [RepoItemViewModel]) {
        viewController.setDataSource(repos)
    }
}
