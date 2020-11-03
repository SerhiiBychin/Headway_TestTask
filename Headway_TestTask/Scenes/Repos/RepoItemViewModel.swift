//
//  RepoItemViewModel.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 28.10.2020.
//

import Foundation

struct RepoItemViewModel: Codable {
    let id: Int
    let repoURL: String
    let name: String
    let imageUrl: String?
}

extension RepoItemViewModel {
    init(repo: Repo) {
        self.id = repo.id
        self.repoURL = repo.htmlURL ?? ""
        self.name = repo.fullName ?? ""
        self.imageUrl = repo.owner?.avatarURL.flatMap { $0 }
    }
}
