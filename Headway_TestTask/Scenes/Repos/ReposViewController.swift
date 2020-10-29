//
//  ReposViewController.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 22.10.2020.
//

import UIKit
import RxSwift
import SafariServices

final class ReposViewController: DisposeViewController {
    private var dataSource: [RepoItem]?
    private let selectedIndexSubject = PublishSubject<RepoItem>()
    var selectedIndex: Observable<RepoItem> {
        return selectedIndexSubject.asObservable()
    }
    
    @IBOutlet private (set) var tableView: UITableView!
    @IBOutlet private (set) var searchBar: UISearchBar!
}


extension ReposViewController: StaticFactory {
    enum Factory {
        static var `default`: ReposViewController {
            let reposVC = R.storyboard.main.reposViewController()!
            let driver = ReposDriver.Factory.default
            let actionBinder = ReposActionBinder(viewController: reposVC, driver: driver)
            let stateBinder = ReposStateBinder.Factory.default(reposVC, driver: driver)
            let navigationBinder = NavigationPushBinder<RepoItem, ReposViewController>.Factory
                .present(viewController: reposVC,
                      driver: driver.didSelect,
                      factory: repoDetailsSafariVC)
            
            
            reposVC.bag.insert(
                stateBinder,
                actionBinder,
                navigationBinder
            )
            
            return reposVC
        }
        
        private static func repoDetailsSafariVC(_ item: RepoItem) -> UIViewController {
            return SFSafariViewController(url: URL(string: item.repoURL)!)
        }
    }
}

extension ReposViewController: UITableViewDataSource, UITableViewDelegate {
    func setDataSource(_ dataSource: [RepoItem]) {
        self.dataSource = dataSource
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
        cell.configure(withRepoItem: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = dataSource else { return }
        selectedIndexSubject.onNext(data[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
