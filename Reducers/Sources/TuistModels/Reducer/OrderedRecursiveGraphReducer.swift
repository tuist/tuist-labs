/// Ordered recursive graph reducer
///
/// - Note: guarantees reducers are applied in the order of registration at the cost of some inefficiency
public class OrderedRecursiveGraphReducer: GraphReducer {
    
    private var reducers: [GraphReducer] = []
    
    public init() {
        
    }
    
    public func register(reducer: GraphReducer) {
        reducers.append(reducer)
    }
    
    public func register(reducer: ProjectModelReducer) {
        let graphReducer = ProjectGraphReducer(reducer: reducer)
        reducers.append(graphReducer)
    }
    
    public func register(reducer: TargetModelReducer) {
        let projectReducer = TargetProjectReducer(reducer: reducer)
        let graphReducer = ProjectGraphReducer(reducer: projectReducer)
        reducers.append(graphReducer)
    }
    
    public func reduce(model: Graph) -> Graph {
        return reducers.reduce(model) { $1.reduce(model: $0) }
    }
}

private class ProjectGraphReducer: GraphReducer {
    let reducer: ProjectModelReducer
    init(reducer: ProjectModelReducer) {
        self.reducer = reducer
    }
    func reduce(model: Graph) -> Graph {
        var updated = model
        updated.projects = updated.projects.map {
            reducer.reduce(model: $0)
        }
        return updated
    }
}

private class TargetProjectReducer: ProjectModelReducer {
    let reducer: TargetModelReducer
    init(reducer: TargetModelReducer) {
        self.reducer = reducer
    }
    func reduce(model: Project) -> Project {
        var updated = model
        updated.targets = updated.targets.map {
            reducer.reduce(model: $0)
        }
        return updated
    }
}
