import TuistCore

// MARK: - 

public struct Project: Equatable {
    public var name: String
    public var targets: [Target]
    // ...
    
    public init(name: String,
                targets: [Target] = []) {
        self.name = name
        self.targets = targets
    }
}

public struct Target: Equatable {
    public var name: String
    public var sources: [AbsolutePath] = []
    // ...
    public var buildPhases: [BuildPhase] = []
    public var dependencies: [TargetDependency] = []
    
    public init(name: String,
                sources: [AbsolutePath] = [],
                buildPhases: [BuildPhase] = [],
                dependencies: [TargetDependency] = []) {
        self.name = name
        self.sources = sources
        self.buildPhases = buildPhases
        self.dependencies = dependencies
    }
}

public enum BuildPhase: Equatable {
    case script(ScriptBuildPhase)
}

public struct ScriptBuildPhase: Equatable {
    public var name: String
    public var script: String
    
    public init(name: String, script: String) {
        self.name = name
        self.script = script
    }
}

public enum TargetDependency: Equatable {
    case target(name: String)
    case project(target: String, path: AbsolutePath)
}
