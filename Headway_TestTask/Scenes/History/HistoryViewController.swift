//
//  HistoryViewController.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 02.11.2020.
//

import Foundation
import UIKit

final class HistoryViewController: DisposeViewController {
    @IBOutlet private (set) var tableView: UITableView!
    @IBOutlet private (set) var doneRightBarButton: UIBarButtonItem!
}


extension HistoryViewController: StaticFactory {
    enum Factory {
        static func `default`(watched repos: [RepoItemViewModel]) -> HistoryViewController {
            let historyVC = R.storyboard.main.historyViewController()!
            return historyVC
        }
    }
}
