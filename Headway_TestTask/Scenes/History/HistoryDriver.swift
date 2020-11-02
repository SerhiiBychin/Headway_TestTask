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
    
    func close()
}

final class HistoryDriver: HistoryDriving {
    private let closeRelay = PublishRelay<Void>()
    private let dataRelay = BehaviorRelay<[RepoItemViewModel]?>(value: nil)
    
    private var repos: [RepoItemViewModel] {
        didSet {
            dataRelay.accept(repos)
        }
    }
    
    var data: Driver<[RepoItemViewModel]> { dataRelay.unwrap().asDriver() }
    var didClose: Driver<Void> { closeRelay.asDriver() }
    
    init(repos: [RepoItemViewModel]) {
        self.repos = repos
    }
    
    func close() {
        closeRelay.accept(())
    }
}


extension HistoryDriver: StaticFactory {
    enum Factory {
        static func `default`(repos: [RepoItemViewModel]) -> HistoryDriving {
            HistoryDriver(repos: repos)
        }        
    }
}
