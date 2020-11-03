//
//  HistoryDriver.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 02.11.2020.
//

import RxSwift
import RxCocoa


protocol HistoryDriving {
    var data: Driver<[RepoItemViewModel]> { get }
    var didClose: Driver<Void> { get }
    var didSelect: Driver<RepoItemViewModel> { get }
    
    func close()
    func select(_ model: RepoItemViewModel)
}

final class HistoryDriver: HistoryDriving {
    private let closeRelay = PublishRelay<Void>()
    private let dataRelay = BehaviorRelay<[RepoItemViewModel]?>(value: nil)
    private let didSelectRelay = BehaviorRelay<RepoItemViewModel?>(value: nil)
    
    var data: Driver<[RepoItemViewModel]> { dataRelay.unwrap().asDriver() }
    var didClose: Driver<Void> { closeRelay.asDriver() }
    var didSelect: Driver<RepoItemViewModel> { didSelectRelay.unwrap().asDriver() }
    
    init(repos: [RepoItemViewModel]) {
        dataRelay.accept(repos)
    }
    
    func close() {
        closeRelay.accept(())
    }
    
    func select(_ model: RepoItemViewModel) {
        didSelectRelay.accept(model)
    }
}


extension HistoryDriver: StaticFactory {
    enum Factory {
        static func `default`(repos: [RepoItemViewModel]) -> HistoryDriving {
            HistoryDriver(repos: repos)
        }        
    }
}
