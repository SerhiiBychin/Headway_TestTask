//
//  ReposDriver.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 28.10.2020.
//

import RxSwift
import RxCocoa
import RxSwiftExt

enum ReposState {
    case none
    case loading
    case results([RepoItem])
}

protocol ReposDriving {
    var state: Driver<ReposState> { get }
    var didSelect: Driver<RepoItem> { get }
    
    
    func select(_ model: RepoItem)
}

final class ReposDriver: ReposDriving {
    private var repoBag = DisposeBag()
    private let stateRelay = BehaviorRelay<ReposState>(value: .none)
    private let didSelectRelay = BehaviorRelay<RepoItem?>(value: nil)
    private var results: Repos? {
        didSet {
            if let repoItems = results?.compactMap({ RepoItem(repo: $0) }) {
                stateRelay.accept(.results(repoItems))
            }
        }
    }
    
    var state: Driver<ReposState> { stateRelay.asDriver() }
    var didSelect: Driver<RepoItem> { didSelectRelay.unwrap().asDriver() }
    
    private let api: GitHubAPIProvider
    
    init(api: GitHubAPIProvider) {
        self.api = api
        bind()
    }
    
    
    func select(_ model: RepoItem) {
        didSelectRelay.accept(model)
    }
    
    private func bind() {
        api.fetchRepos()
            .bind(onNext: set(unowned: self, to: \.results))
            .disposed(by: repoBag)
    }
}

extension ReposDriver: StaticFactory {
    enum Factory {
        static var `default`: ReposDriving {
            ReposDriver(api: GitHubAPIService.Factory.default)
        }
    }
}
