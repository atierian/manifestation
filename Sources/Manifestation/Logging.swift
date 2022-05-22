//
//  File.swift
//  
//
//  Created by Ian Saultz on 5/21/22.
//

import Foundation
import Basics

struct Logging {
    let observabilityHandler: (ObservabilityScope, Basics.Diagnostic) -> Void
    
    static let verbose = Logging(
        observabilityHandler: { print("\($0): \($1)") }
    )
    
    static let standard = Logging(
        observabilityHandler: { _, _ in }
    )
}

extension Logging {
    init(verbose: Bool) {
        self = verbose ? .verbose : .standard
    }
}
