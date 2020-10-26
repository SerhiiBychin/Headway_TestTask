//
//  DefaultInitializable.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 25.10.2020.
//

import Foundation

protocol StaticFactory {
    associatedtype Factory
}

extension StaticFactory {
    static var factory: Factory.Type { return Factory.self }
}
