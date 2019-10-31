import TuistCore
import TuistModels
import TuistGenerator
import ProjectDescription

class Demo {
    private let generator: Generating
    private let manifestLoader: ManifestLoading
    private let projectWriter: ProjectDescriptorWriting
    
    init(generator: Generating,
         manifestLoader: ManifestLoading,
         projectWriter: ProjectDescriptorWriting) {
        self.generator = generator
        self.manifestLoader = manifestLoader
        self.projectWriter = projectWriter
    }

    func generateProject(at path: AbsolutePath) throws {
        
        // Load models
        let models = loadModels(at: path)

        // Lint graph
        let linter = createLinter()
        let lintIssues = linter.lint(model: models.graph)
        display(lintIssues: lintIssues)

        // Update graph
        let reucer = createGraphReducer(from: models)
        let updatedGraph = reucer.reduce(model: models.graph)

        // Generate XcodeProj
        let project = try generator.generateProject(graph: updatedGraph)

        // Other Side effects
        let infoPlistGenerator = InfoPlistGenerator(targets: infoPlistTargets(from: models))
        infoPlistGenerator.generate()
        
        // Write to disk
        try write(project: project, path: path)
    }

    // MARK: -
    
    private func createLinter() -> RecursiveGraphLinter {
        let linter = RecursiveGraphLinter()
        
        // ...
        
        return linter
    }
    
    private func createGraphReducer(from models: Models) -> GraphReducer {
        let reducer = OrderedRecursiveGraphReducer()
        
        // Order matters
        reducer.register(reducer: SwiftLintReducer())
        reducer.register(reducer: ManifestTargetReducer())
        reducer.register(reducer: ManifestProjectReducer())
        reducer.register(reducer: GeneratedSourcesReducer())
        reducer.register(reducer: InfoPlistReducer(targets: infoPlistTargets(from: models)))
        // ...
        
        return reducer
    }
    
    private func infoPlistTargets(from models: Models) -> [InfoPlistGenerator.TargetIdentifier] {
        let infoPlistTargets = Array(models.manifests).flatMap { (arg) -> [InfoPlistGenerator.TargetIdentifier] in
            let (path, manifest) = arg
            let targets = manifest.targets.filter { $0.infoPlist == .default }
            let temp = targets.map { InfoPlistGenerator.TargetIdentifier(path: path, target: $0.name) }
            return temp
        }
        return infoPlistTargets
    }
    
    private func loadModels(at path: AbsolutePath) -> Models {
        // Manifest > Graph + Models
        //
        // Transforms from `ProjectDescription` > `TuistModel`
        // ...
        return Models(graph: Graph(), manifests: [:])
    }
    
    private func display(lintIssues: [LintingIssue]) {
        // ...
    }
    
    private func write(project: ProjectDescriptor, path: AbsolutePath) throws {
        try projectWriter.write(descriptor: project, to: path)
    }
}


// MARK: -

struct Models {
    var graph: Graph
    var manifests: [AbsolutePath: ProjectDescription.Project]
}

