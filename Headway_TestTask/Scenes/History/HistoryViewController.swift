//
//  HistoryViewController.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 02.11.2020.
//

import Foundation
import UIKit
import RxSwift

final class HistoryViewController: DisposeViewController {
    private var dataSource: [RepoItemViewModel]?
    
    private let selectedIndexSubject = PublishSubject<RepoItemViewModel>()
    var selectedIndex: Observable<RepoItemViewModel> {
        return selectedIndexSubject.asObservable()
    }
    
    
    @IBOutlet private (set) var tableView: UITableView!
    @IBOutlet private (set) var doneRightBarButton: UIBarButtonItem!
}


extension HistoryViewController: StaticFactory {
    enum Factory {
        static func `default`(repos: [RepoItemViewModel]) -> HistoryViewController {
            let historyVC = R.storyboard.main.historyViewController()!
            let driver = HistoryDriver.Factory.default(repos: repos)
            let actionBinder = HistoryActionBinder(viewController: historyVC, driver: driver)
            let stateBinder = HistoryStateBinder(viewController: historyVC, driver: driver)
            let navigationBinder = DismissBinder<HistoryViewController>.Factory
                .dismiss(viewController: historyVC, driver: driver.didClose)
            
            historyVC.bag.insert(
                stateBinder,
                actionBinder,
                navigationBinder
            )
            
            return historyVC
        }
    }
}


extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func setDataSource(_ dataSource: [RepoItemViewModel]) {
        self.dataSource = dataSource
        tableView.reloadData()
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = dataSource else { return UITableViewCell() } // No-op
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.repoTableViewCell,
                                                 for: indexPath)!
        cell.configure(withRepoItem: data[indexPath.row], selectedItems: [])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = dataSource else { return }
        
        selectedIndexSubject.onNext(data[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
