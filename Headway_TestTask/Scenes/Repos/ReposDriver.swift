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
    case results([RepoItemViewModel])
    case searchResults([RepoItemViewModel])
    case showWatchedRepos([RepoItemViewModel])
}

protocol ReposDriving {
    var state: Driver<ReposState> { get }
    var didSelect: Driver<RepoItemViewModel> { get }
    
    
    func select(_ model: RepoItemViewModel)
    func search(_ query: String)
    func save(repos: [RepoItemViewModel])
    func showWatchedRepos()
}

final class ReposDriver: ReposDriving {
    private var repoBag = DisposeBag()
    private let activityIndicator = ActivityIndicator()
    private let stateRelay = BehaviorRelay<ReposState>(value: .none)
    private let didSelectRelay = BehaviorRelay<RepoItemViewModel?>(value: nil)
    private var results: Repos? {
        didSet {
            if let repoItems = results?.compactMap({ RepoItemViewModel(repo: $0) }) {
                stateRelay.accept(.results(repoItems))
            }
        }
    }
    
    private var searchResults: [RepoItemViewModel]? {
        didSet {
            if let repoItems = searchResults {
                stateRelay.accept(.searchResults(repoItems))
            }
        }
    }
    
    var state: Driver<ReposState> { stateRelay.asDriver() }
    var didSelect: Driver<RepoItemViewModel> { didSelectRelay.unwrap().asDriver() }
    
    private let api: GitHubAPIProvider
    private let storage: StorageSavable
    
    init(api: GitHubAPIProvider, storage: StorageSavable = Storage()) {
        self.api = api
        self.storage = storage
        bind()
    }
    
    
    func select(_ model: RepoItemViewModel) {
        didSelectRelay.accept(model)
    }
    
    
    func search(_ query: String) {
        let isValid = query.count >= 3
        
        guard isValid else {
            if let userRepos = results?.compactMap({ RepoItemViewModel(repo: $0) }) {
                stateRelay.accept(.results(userRepos))                
            }
            return
        }
        
        let searchResult: Observable<[RepoItemViewModel]>
        
        searchResult = api.searchRepos(forQuery: query)
            .map({ $0 ?? [] })
            .mapMany(RepoItemViewModel.init)
        
        searchResult
            .trackActivity(activityIndicator)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: set(unowned: self, to: \.searchResults))
            .disposed(by: repoBag)
    }
    
    
    func save(repos: [RepoItemViewModel]) {
        try? storage.saveObject(repos, forKey: "WatchedRepos")
    }
    
    func showWatchedRepos() {
        guard let repos = try? storage.getObject(forKey: "WatchedRepos", castTo: [RepoItemViewModel].self) else { return }
        stateRelay.accept(.showWatchedRepos(repos))
    }
    
    private func bind() {
        api.fetchRepos()
            .bind(onNext: set(unowned: self, to: \.results))
            .disposed(by: repoBag)
        
        activityIndicator
            .filter({ $0 })
            .map({ _ in ReposState.loading })
            .drive(onNext: stateRelay.accept)
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
