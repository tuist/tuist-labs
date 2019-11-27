
import Foundation

public class OrderedGraphTransformer: GraphTransforming {
    
    private var transformers: [GraphTransforming] = []
    
    public init() {
        
    }
    
    public func register(transformer: GraphTransforming) {
        transformers.append(transformer)
    }
    
    public func register(transformer: ProjectTransforming) {
        let graphTransformer = ProjectGraphTransformer(transformer: transformer)
        transformers.append(graphTransformer)
    }
    
    public func register(transformer: TargetTransforming) {
        let projectTransformer = TargetProjectTransformer(transformer: transformer)
        let graphTransformer = ProjectGraphTransformer(transformer: projectTransformer)
        transformers.append(graphTransformer)
    }

    public func transform(model: Graph) throws -> Transformation<Graph> {
        let initial = Transformation(model: model, sideEffects: [])
        return try transformers.reduce(initial) {
            let transformation = try $1.transform(model: $0.model)
            return $0.replacing(model: transformation.model)
                     .adding(sideEffects: transformation.sideEffects)
        }
    }
}

private class ProjectGraphTransformer: GraphTransforming {
    let transformer: ProjectTransforming
    init(transformer: ProjectTransforming) {
        self.transformer = transformer
    }
    func transform(model: Graph) throws -> Transformation<Graph> {
        var updated = model
        let transformations = try updated.projects.map {
            try transformer.transform(model: $0)
        }
        updated.projects = transformations.map { $0.model }
        return Transformation(model: updated,
                              sideEffects: transformations.flatMap { $0.sideEffects })
    }
}

private class TargetProjectTransformer: ProjectTransforming {
    let transformer: TargetTransforming
    init(transformer: TargetTransforming) {
        self.transformer
            = transformer
    }
    func transform(model: Project) throws -> Transformation<Project> {
        var updated = model
        let transformations = try updated.targets.map {
            try transformer.transform(model: $0)
        }
        updated.targets = transformations.map { $0.model }
        return Transformation(model: updated,
                              sideEffects: transformations.flatMap { $0.sideEffects })
    }
}
