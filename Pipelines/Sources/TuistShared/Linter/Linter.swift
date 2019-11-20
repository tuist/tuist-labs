public protocol GraphLinting {
    func lint(model: Graph) -> [LintingIssue]
}

public protocol ProjectLinting {
    func lint(model: Project) -> [LintingIssue]
}

public protocol TargetLinting {
    func lint(model: Target) -> [LintingIssue]
}
