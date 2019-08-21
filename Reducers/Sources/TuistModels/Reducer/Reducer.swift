
public protocol GraphReducer {
    func reduce(model: Graph) -> Graph
}

public protocol ProjectModelReducer {
    func reduce(model: Project) -> Project
}

public protocol TargetModelReducer {
    func reduce(model: Target) -> Target
}
