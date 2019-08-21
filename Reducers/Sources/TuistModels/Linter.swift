
public struct LintingIssue {
    
}

public protocol GraphLinting {
    func lint(model: Graph) -> [LintingIssue]
}

public protocol ProjectModelLinting {
    func lint(model: Project) -> [LintingIssue]
}

public protocol TargetModelLinting {
    func lint(model: Target) -> [LintingIssue]
}

public class RecursiveGraphLinter {
    private var grapLinters: [GraphLinting] = []
    private var projectModelLinters: [ProjectModelLinting] = []
    private var targetModelLinters: [TargetModelLinting] = []
    
    public init() {
        
    }
    
    public func register(linter: GraphLinting) {
        grapLinters.append(linter)
    }
    
    public func register(linter: ProjectModelLinting) {
        projectModelLinters.append(linter)
    }
    
    public func register(linter: TargetModelLinting) {
        targetModelLinters.append(linter)
    }
    
    public func lint(model: Graph) -> [LintingIssue] {
        var results = grapLinters.flatMap { $0.lint(model: model) }
        results += model.projects.flatMap { lint(model: $0) }
        return results
    }
    
    private func lint(model: Project) -> [LintingIssue] {
        var result = projectModelLinters.flatMap { $0.lint(model: model) }
        result += model.targets.flatMap { lint(model: $0) }
        return result
    }
    
    private func lint(model: Target) -> [LintingIssue] {
        return targetModelLinters.flatMap { $0.lint(model: model) }
    }
}
