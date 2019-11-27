
import Foundation

public struct Transformation<Model> {
    public var model: Model
    public var sideEffects: [SideEffect]
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
    func transform(model: Graph) throws -> Transformation<Graph>
}

public protocol ProjectTransforming {
    func transform(model: Project) throws -> Transformation<Project>
}

public protocol TargetTransforming {
    func transform(model: Target) throws -> Transformation<Target>
}
