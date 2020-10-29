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
}

protocol ReposDriving {
    var state: Driver<ReposState> { get }
    var didSelect: Driver<RepoItemViewModel> { get }
    
    
    func select(_ model: RepoItemViewModel)
    func search(_ query: String)
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
    
    init(api: GitHubAPIProvider) {
        self.api = api
        bind()
    }
    
    
    func select(_ model: RepoItemViewModel) {
        didSelectRelay.accept(model)
    }
    
    
    func search(_ query: String) {
        let isValid = query.count >= 3
        
        guard isValid else {
            stateRelay.accept(.searchResults([RepoItemViewModel]()))
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
