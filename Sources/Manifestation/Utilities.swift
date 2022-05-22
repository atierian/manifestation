//
//  File.swift
//  
//
//  Created by Ian Saultz on 5/22/22.
//

import Foundation

extension Collection {
    func sum<T: AdditiveArithmetic>(
        initial: T,
        adding keyPath: KeyPath<Element, T>
    ) -> T {
        reduce(.zero) { $0 + $1[keyPath: keyPath] }
    }
}
