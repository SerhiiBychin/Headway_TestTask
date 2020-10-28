//
//  ReposViewController.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 22.10.2020.
//

import UIKit

final class ReposViewController: DisposeViewController {
    @IBOutlet private (set) var tableView: UITableView!
    @IBOutlet private (set) var searchBar: UISearchBar!
}


extension ReposViewController: StaticFactory {
    enum Factory {
        static var `default`: ReposViewController {
            let reposVC = R.storyboard.main.reposViewController()!
            
            return reposVC
        }
    }
}
