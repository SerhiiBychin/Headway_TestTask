//
//  ViewControllerBinder.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 26.10.2020.
//

import Foundation
import RxSwift
import RxViewController

protocol ViewControllerBinder: Disposable {
    associatedtype DisposeViewControllerContainer: UIViewController, DisposeContainer
    
    var viewController: DisposeViewControllerContainer { get }
    
    func bindLoaded()
}

extension ViewControllerBinder {
    var bag: DisposeBag {
        viewController.bag
    }
}

extension ViewControllerBinder where Self: AnyObject {
    func bind() {
        viewController.rx.viewDidLoad
            .subscribe(onNext: unowned(self, in: Self.bindLoaded))
            .disposed(by: viewController.bag)
    }
    
    var binded: Self {
        bind()
        return self
    }
}
