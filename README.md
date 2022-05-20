# manifestation

## Overview
manifestation is a command line tool that parses the content of a Swift Package manifest (Package.swift file) and generates a report based on it.

## Installation
`git clone https://github.com/atierian/manifestation.git` or use SSH if you're so inclined.

`cd manifestation`

Then decide if you want to install this globally or not. If so, you'll run:

`swift build --configuration release`

`cp -f .build/release/manifestation /usr/local/bin/manifestation`

If you don't want to, you'll just need to prefix the commands listed below with `swift run`
e.g.

`swift run manifestation ~/Projects/FooKit --dump`


```
OVERVIEW: Parse a Package.swift manifest.

USAGE: manifestation <path> [--dump]

ARGUMENTS:
  <path>                  The path to the Package.swift.

OPTIONS:
  -d, --dump              Dump the entire package manifest
  -h, --help              Show help information.
```

## Usage
Provide the **absolute** path to the directory containing your `Package.swift`.
For example, if you have a `Package.swift` here `/Users/Foo/Projects/FooKit/Package.swift`, you would run:

`manifestation /Users/Foo/Projects/FooKit` or `manifestation ~/Projects/FooKit`

Here's the output from the `Package.swift` of `manifestation` as an example:
```
Loading manifest: [debug]: evaluating manifest for 'manifestation' v. unknown
Loading manifest: [debug]: loading manifest for 'manifestation' v. unknown from cache
Loading manifest: [debug]: loading manifest for 'manifestation' v. unknown from cache
Loading manifest: [debug]: evaluating manifest for 'swift-argument-parser' v. unknown
Loading manifest: [debug]: evaluating manifest for 'swift-package-manager' v. unknown
Loading manifest: [debug]: evaluating manifest for 'swift-llbuild' v. unknown
Loading manifest: [debug]: evaluating manifest for 'swift-crypto' v. 1.1.7
Loading manifest: [debug]: evaluating manifest for 'swift-system' v. 1.1.1
Loading manifest: [debug]: evaluating manifest for 'swift-collections' v. 1.0.2
Loading manifest: [debug]: evaluating manifest for 'swift-tools-support-core' v. unknown
Loading manifest: [debug]: evaluating manifest for 'swift-driver' v. unknown
Loading manifest: [debug]: evaluating manifest for 'yams' v. 4.0.6
Validating package dependencies: [info]: dependency on 'swift-argument-parser' is represented by similar locations ('https://github.com/apple/swift-argument-parser' and 'https://github.com/apple/swift-argument-parser.git') which are treated as the same canonical location 'github.com/apple/swift-argument-parser'.
>>>>> Products <<<<<
Name: manifestation
    - Type: executable
    - Targets: ["Manifestation"]

>>>>> Targets <<<<<
Name: Manifestation
    - Type: executable
    - Dependencies: [ ArgumentParser, SwiftPM ]
    - Path:
    - URL:
    - Settings: []
    - Exclude: []
    - Resources: []

Name: ManifestationTests
    - Type: test
    - Dependencies: [ Manifestation ]
    - Path:
    - URL:
    - Settings: []
    - Exclude: []
    - Resources: []
```

Using the flag `--dump` with dump the entire `Manifest` object into your console, providing a lot of detail.

You might be asking why the hell the entirety of swift-package-manager is included in this repo. SPM pins its dependency on Swift Argument Parser to a version previous to argument parser's addition of `AsyncParsableCommand`. Since I was too lazy to use `CommandLine` APIs to make this, I just pulled in swift-package-manager locally, changed it to depend on the `main` branch of Swift Argument Parser, and it worked 🤷.
