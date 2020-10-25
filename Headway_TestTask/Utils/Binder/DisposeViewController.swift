//
//  DisposeViewController.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 25.10.2020.
//

import Foundation
import RxSwift

protocol DisposeContainer {
    var bag: DisposeBag { get }
}

class DisposeViewController: UIViewController, DisposeContainer {
    let bag = DisposeBag()
    
}
