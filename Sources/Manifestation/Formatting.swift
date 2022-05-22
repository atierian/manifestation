//
//  File.swift
//  
//
//  Created by Ian Saultz on 5/21/22.
//

import PackageModel

struct Formatting<A, B> {
    let format: (A) -> B
}

extension Formatting where A == [ProductDescription], B == [String] {
    static let products = Self { products in
        products.map {
            """
            Name: \($0.name)
                - Type: \($0.type)
                - Targets: \($0.targets)

            """
        }
    }
}

extension Formatting where A == [TargetDescription], B == [String] {
    static let targets = Self { targets in
        func parseDependencies(_ deps: [TargetDescription.Dependency]) -> String {
            deps.reduce("[  ") {
                switch $1 {
                case .target(let name, _),
                        .byName(let name, _),
                        .product(let name, _, _, _):
                    return $0 + name + ", "
                }
            }
            .dropLast(2)
            + "  ]"
        }
        
        return targets.map {
            """
            Name: \($0.name)
                - Type: \($0.type)
                - Dependencies: \(parseDependencies($0.dependencies))
                - Path: \($0.path ?? "")
                - URL: \($0.url ?? "")
                - Settings: \($0.settings)
                - Exclude: \($0.exclude)
                - Resources: \($0.resources)

            """
        }
    }
}
