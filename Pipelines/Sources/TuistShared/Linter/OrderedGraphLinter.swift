public class OrdereredGraphLinter: GraphLinting {
    private var linters: [GraphLinting] = []
    
    public init() {
        
    }
    
    public func register(linter: GraphLinting) {
        linters.append(linter)
    }
    
    public func register(linter: ProjectLinting) {
        let graphLinter = ProjectGraphLinter(linter: linter)
        linters.append(graphLinter)
    }
    
    public func register(linter: TargetLinting) {
//        let projectTransformer = TargetProjectTransformer(transformer: transformer)
//        let graphTransformer = ProjectGraphTransformer(transformer: projectTransformer)
//        transformers.append(graphTransformer)
    }

    public func lint(model: Graph) -> [LintingIssue] {
        linters.flatMap { $0.lint(model: model) }
    }
}

private class ProjectGraphLinter: GraphLinting {
    let linter: ProjectLinting
    init(linter: ProjectLinting) {
        self.linter = linter
    }
    
    func lint(model: Graph) -> [LintingIssue] {
        model.projects.flatMap(linter.lint)
    }
}


public protocol GraphLinting {
    func lint(model: Graph) -> [LintingIssue]
}

public protocol ProjectLinting {
    func lint(model: Project) -> [LintingIssue]
}

public protocol TargetLinting {
    func lint(model: Target) -> [LintingIssue]
}

/// Linting issue.
public struct LintingIssue: CustomStringConvertible {
    public enum Severity: String {
        case warning
        case error
    }
    public let reason: String
    public let severity: Severity
    public init(reason: String, severity: Severity) {
        self.reason = reason
        self.severity = severity
    }
    public var description: String {
        return reason
    }
}
