//
//  RepoItemViewModel.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 28.10.2020.
//

import Foundation

struct RepoItem {
    let id: Int
    let repoURL: String
    let name: String
    let imageUrl: String?
}

extension RepoItem {
    init(repo: Repo) {
        self.id = repo.id
        self.repoURL = repo.htmlURL ?? ""
        self.name = repo.fullName ?? ""
        self.imageUrl = repo.owner?.avatarURL.flatMap { $0 }
    }
}
