//
//  HistoryActionBinder.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 02.11.2020.
//

import Foundation

final class HistoryActionBinder: ViewControllerBinder {
    unowned let viewController: HistoryViewController
    private let driver: HistoryDriver
    
    init(viewController: HistoryViewController,
         driver: HistoryDriver) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }
    
    func dispose() { }
    
    func bindLoaded() {
        viewController.bag.insert(
            viewController.doneRightBarButton.rx.tap
                .bind(onNext: driver.close)
        )
    }
}
