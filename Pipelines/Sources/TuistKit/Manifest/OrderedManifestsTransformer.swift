import ProjectDescription
import struct TuistShared.Transformation
import struct TuistShared.SideEffect
import TuistSupport

public class OrderedManifestsTransformer: ManifestsTransforming {

    private var transformers: [ManifestsTransforming] = []

    public init() {

    }
    
    public func register(transformer: ManifestsTransforming) {
        transformers.append(transformer)
    }
    
    public func register(transformer: ProjectManifestTransforming) {
        let projectManifestTransformer = ManifestsProjectManifestTransfomer(transformer: transformer)
        transformers.append(projectManifestTransformer)
    }

    public func register(transformer: ProjectTransforming) {
        let manifestProjectTransformer = ManifestProjectTransformer(transformer: transformer)
        register(transformer: manifestProjectTransformer)
    }

    public func register(transformer: TargetTransforming) {
        let projectTransformer = ManifestTargetProjectTransformer(transformer: transformer)
        register(transformer: projectTransformer)
    }

    public func transform(model: Manifests) throws -> Transformation<Manifests> {
        let initial = Transformation(model: model, sideEffects: [])
        return try transformers.reduce(initial) {
            let transformation = try $1.transform(model: $0.model)
            return $0.replacing(model: transformation.model)
                     .adding(sideEffects: transformation.sideEffects)
        }
    }
}

private class ManifestsProjectManifestTransfomer: ManifestsTransforming {
    let transformer: ProjectManifestTransforming
    init(transformer: ProjectManifestTransforming) {
        self.transformer = transformer
    }
    
    func transform(model: Manifests) throws -> Transformation<Manifests> {
        var updated = model
        let transformations = try updated.projects.map {
            try transformer.transform(model: $0)
        }
        updated.projects = transformations.map { $0.model }
        return Transformation(model: updated, sideEffects: transformations.flatMap { $0.sideEffects })
    }
}

private class ManifestProjectTransformer: ProjectManifestTransforming {
    let transformer: ProjectTransforming
    init(transformer: ProjectTransforming) {
        self.transformer = transformer
    }
    
    func transform(model: ProjectManifest) throws -> Transformation<ProjectManifest> {
        var updated = model
        let transformation = try transformer.transform(model: updated.manifest)
        updated.manifest = transformation.model
        return Transformation(model: updated, sideEffects: transformation.sideEffects)
    }
}

private class ManifestTargetProjectTransformer: ProjectTransforming {
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

public protocol ManifestsTransforming {
    func transform(model: Manifests) throws -> Transformation<Manifests>
}

public protocol ProjectManifestTransforming {
    func transform(model: ProjectManifest) throws -> Transformation<ProjectManifest>
}

public protocol ProjectTransforming {
    func transform(model: Project) throws -> Transformation<Project>
}

public protocol TargetTransforming {
    func transform(model: Target) throws -> Transformation<Target>
}

public protocol TargetActionTransforming {
    func transform(model: TargetAction) throws -> Transformation<TargetAction>
}

public class InfoPlistTransformer: TargetTransforming {
    public func transform(model: Target) throws -> Transformation<Target> {
        return Transformation(model: model,
                              sideEffects: [SideEffect(action: .createFile(SideEffect.File(path: AbsolutePath("/InfoPlist"))),
                                 category: .preGeneration)])
    }
}
