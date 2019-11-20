public class OrderedGraphLinter: GraphLinting {
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
        let projectLinter = TargetProjectLinter(linter: linter)
        let graphLinter = ProjectGraphLinter(linter: projectLinter)
        linters.append(graphLinter)
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

private class TargetProjectLinter: ProjectLinting {    
    let linter: TargetLinting
    init(linter: TargetLinting) {
        self.linter = linter
    }
    
    func lint(model: Project) -> [LintingIssue] {
        model.targets.flatMap(linter.lint)
    }
}

/// Linting issue.
public struct LintingIssue: CustomStringConvertible, Equatable {
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
    
    // MARK: - Equatable

    public static func == (lhs: LintingIssue, rhs: LintingIssue) -> Bool {
        return lhs.severity == rhs.severity &&
            lhs.reason == rhs.reason
    }
}
