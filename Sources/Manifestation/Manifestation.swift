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
    
    @Argument(help: "The absolute path to the Package.swift. e.g. '~/Foo/Bar")
    private var path: String

    @Flag(name: .shortAndLong, help: "Dump the entire package manifest")
    private var dump = false
    
    @Flag(help: "Verbose logging. This will print all events from the 'ObservabilitySystem'")
    private var verbose = false
    
    mutating func run() async throws {
        let observabilityHandler = Logging(verbose: verbose)
            .observabilityHandler
        let observability = ObservabilitySystem(observabilityHandler)
        
        let packagePath = AbsolutePath(path)
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
        
        outputToConsole(
            from: manifest.products,
            formatting: .products,
            header: "Products"
        )
        
        outputToConsole(
            from: manifest.targets,
            formatting: .targets,
            header: "Targets"
        )
        
        let numberOfFiles = graph.reachableTargets
            .sum(initial: 0, adding: \.sources.paths.count)
        print("Total number of source files (including dependencies):", numberOfFiles)
        
        if dump {
            print("Manifest")
            Swift.dump(manifest)
        }
    }
    
    private func outputToConsole<T>(
        from input: T,
        formatting: Formatting<T, [String]>,
        header: String
    ) {
        print(">>>>> \(header) <<<<<")
        formatting.format(input)
            .forEach { print($0) }
    }
}

