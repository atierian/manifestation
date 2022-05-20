import ArgumentParser
import llbuildBasic
import TSCBasic
import Workspace
import Basics
import PackageCollections
import PackageModel

@main
struct Manifestation: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Parse a Package.swift manifest."
    )
    
    @Argument(help: "The path to the Package.swift.")
    private var path: String

    @Flag(name: .shortAndLong, help: "Dump the entire package manifest")
    private var dump = false
    
    mutating func run() async throws {
        let packagePath = AbsolutePath(path)
        let observability = ObservabilitySystem({ print("\($0): \($1)") })
        let workspace = try Workspace(forRootPackage: packagePath)
        
        let manifest = try await workspace.loadRootManifest(
            at: packagePath,
            observabilityScope: observability.topScope
        )
        
        _ = try await workspace.loadRootPackage(
            at: packagePath,
            observabilityScope: observability.topScope
        )
        
        let graph = try workspace.loadPackageGraph(
            rootPath: packagePath,
            observabilityScope: observability.topScope
        )
        
        print(">>>>> Products <<<<<")
        Formatting.products.format(manifest.products)
            .forEach { print($0) }
        
        print(">>>>> Targets <<<<<")
        Formatting.targets.format(manifest.targets)
            .forEach { print($0) }
        
        let numberOfFiles = graph.reachableTargets
            .reduce(0) { $0 + $1.sources.paths.count }
        print("Total number of source files (including dependencies):", numberOfFiles)
        
        if dump {
            print("Manifest")
            Swift.dump(manifest)
        }
    }
}

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
            deps.reduce("[ ") {
                switch $1 {
                case .target(let name, _),
                        .byName(let name, _),
                        .product(let name, _, _, _):
                    return $0 + name + ", "
                }
                
            }
            .dropLast(2)
            + " ]"
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
