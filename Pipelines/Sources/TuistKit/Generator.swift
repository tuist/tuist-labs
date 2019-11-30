
import Foundation
import TuistShared
import TuistSupport
import TuistXcodeProjGenerator

public final class Generator {
    private let manifestLoader: GraphManifestLoader
    private let graphBuilder: GraphBuilding
    private let sideEffectActionHandler: SideEffectActionHandling
    private let xcodeProjGenerator: XcodeProjGenerating
    
    init(manifestLoader: GraphManifestLoader,
         graphBuilder: GraphBuilding,
         sideEffectActionHandler: SideEffectActionHandling,
         xcodeProjGenerator: XcodeProjGenerating) {
        self.manifestLoader = manifestLoader
        self.graphBuilder = graphBuilder
        self.sideEffectActionHandler = sideEffectActionHandler
        self.xcodeProjGenerator = xcodeProjGenerator
    }
    
    public func generate(at path: AbsolutePath) throws {
        // Load transformers
        let transformer = loadTransformers()
        
        // Load models
        let modelsTransformation = try loadModels(at: path)
        var models = modelsTransformation.model
        
        // Load linters
        // TODO
        
        // Run Linters
        // TODO
        
        // Run transformers
        var transformation = try transformer.transform(model: models.graph)
        // Combining transformation from manifest > model conversion and graph transformation
        transformation.sideEffects = modelsTransformation.sideEffects + transformation.sideEffects
        models.graph = transformation.model
        
        // Run pre-generation side effects
        let preGenerationSideEffects = transformation
                                            .sideEffects
                                            .filter { $0.category == .preGeneration }
                                            .map { $0.action }
        try sideEffectActionHandler.handle(sideEffects: preGenerationSideEffects)
        
        // Run path unfolds
        models.graph = unfoldPaths(graph: models.graph)
        
        // Generate XcodeProj descriptors
        let descriptor = xcodeProjGenerator.generateWorkspace(grap: models.graph)
        
        // Write projects
        try write(descriptor)
        
        // Run post-generation side effects
        let postGenerationSideEffects = transformation
                                            .sideEffects
                                            .filter { $0.category == .postGeneration }
                                            .map { $0.action }
        try sideEffectActionHandler.handle(sideEffects: postGenerationSideEffects)
    }
    
    // MARK: -
    
    private func loadModels(at path: AbsolutePath) throws -> Transformation<Models> {
        // Load all manifests
        var manifests = manifestLoader.load(at: path)
        
        // Load manifest transfomer
        let transformer = OrderedManifestsTransformer()
        transformer.register(transformer: InfoPlistTransformer())
        
        let transformation = try transformer.transform(model: manifests)
        manifests = transformation.model
        
        // Convert to models
        let models = convert(manifests: manifests)
        
        // Build Graph
        let graph = graphBuilder.build(workspace: nil, projects: models)
        
        return Transformation(model: Models(graph: graph, manifests: manifests), sideEffects: transformation.sideEffects)
    }
    
    private func convert(manifests: Manifests) -> [Project] {
        return manifests.projects.map {
            ManifestModelConverter(path: $0.path)
                .convert(manifest: $0.manifest)
        }
    }
    
    private func loadTransformers() -> OrderedGraphTransformer {
        let transformer = OrderedGraphTransformer()
        
        // Register transformers here
        
        return transformer
    }
    
    private func unfoldPaths(graph: Graph) -> Graph {
        return graph
    }
    
    private func write(_ workspaceDescriptor: WorkspaceDescriptor) throws {
        // ...
    }

    private func write(_ projectDescriptor: ProjectDescriptor) throws {
        // ...
    }
}
