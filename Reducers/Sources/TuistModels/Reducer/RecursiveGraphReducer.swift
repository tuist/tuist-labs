
public class RecursiveGraphReducer: GraphReducer {
    private var graphReducers: [GraphReducer] = []
    private var projectModelReducers: [ProjectModelReducer] = []
    private var targetModelReducers: [TargetModelReducer] = []
    
    public init() {
        
    }
    
    public func register(reducer: GraphReducer) {
        graphReducers.append(reducer)
    }
    
    public func register(reducer: ProjectModelReducer) {
        projectModelReducers.append(reducer)
    }
    
    public func register(reducer: TargetModelReducer) {
        targetModelReducers.append(reducer)
    }
    
    public func reduce(model: Graph) -> Graph {
        var graph = graphReducers.reduce(model) { $1.reduce(model: $0) }
        graph.projects = graph.projects.map { reduce(model: $0) }
        return graph
    }
    
    private func reduce(model: Project) -> Project {
        var project = projectModelReducers.reduce(model) { $1.reduce(model: $0) }
        project.targets = project.targets.map { reduce(model: $0) }
        return project
    }
    
    private func reduce(model: Target) -> Target {
        return targetModelReducers.reduce(model) { $1.reduce(model: $0) }
    }
}

