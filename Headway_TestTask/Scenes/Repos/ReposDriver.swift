//
//  ReposDriver.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 28.10.2020.
//

import RxSwift
import RxCocoa
import RxSwiftExt

protocol ReposDriving {
    var isLoading: Driver<Bool> { get }
    var results: Driver<[RepoItem]> { get }
    var didSelect: Driver<RepoItem> { get }
    
    func provideUserRepos()
    func select(_ model: RepoItem)
}

final class ReposDriver: ReposDriving {
    private let activityIndicator = ActivityIndicator()
    
    private let resultsRelay = BehaviorRelay<[RepoItem]?>(value: nil)
    private let didSelectRelay = BehaviorRelay<RepoItem?>(value: nil)
    
    private var repoBag = DisposeBag()
    
    private let api: GitHubAPIProvider
    
    var isLoading: Driver<Bool> { activityIndicator.asDriver() }
    var results: Driver<[RepoItem]> { resultsRelay.unwrap().asDriver() }
    var didSelect: Driver<RepoItem> { didSelectRelay.unwrap().asDriver() }
    
    init(api: GitHubAPIProvider) {
        self.api = api
    }
    
    func provideUserRepos() {
        repoBag = DisposeBag()
        
        let userRepos: Observable<[RepoItem]>
        
        userRepos = api.fetchRepos()
            .map({ $0 ?? [] })
            .mapMany(RepoItem.init)
        
        userRepos
            .trackActivity(activityIndicator)
            .bind(onNext: resultsRelay.accept)
            .disposed(by: repoBag)
    }
    
    
    func select(_ model: RepoItem) {
        didSelectRelay.accept(model)
    }
}

extension ReposDriver: StaticFactory {
    enum Factory {
        static var `default`: ReposDriving {
            ReposDriver(api: GitHubAPIService.Factory.default)
        }
    }
}
