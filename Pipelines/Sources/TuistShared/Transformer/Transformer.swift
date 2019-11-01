
import Foundation

public struct Transformation<Model> {
    var model: Model
    var sideEffects: [SideEffect]
    public init(model: Model, sideEffects: [SideEffect] = []) {
        self.model = model
        self.sideEffects = sideEffects
    }
}

extension Transformation {
    func replacing(model: Model) -> Transformation<Model> {
        return Transformation(model: model, sideEffects: sideEffects)
    }
    
    func adding(sideEffects additionalSideEffects: [SideEffect]) -> Transformation {
        return Transformation(model: model,
                              sideEffects: sideEffects + additionalSideEffects)
    }
}

public protocol GraphTransforming {
    func transform(model: Graph) -> Transformation<Graph>
}

public protocol ProjectTransforming {
    func transform(model: Project) -> Transformation<Project>
}

public protocol TargetTransforming {
    func transform(model: Target) -> Transformation<Target>
}
