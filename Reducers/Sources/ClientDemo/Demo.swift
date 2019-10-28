import TuistCore
import TuistModels
import TuistGenerator

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
        let graph = loadGraph(at: path)

        // Lint graph
        let linter = createLinter()
        let lintIssues = linter.lint(model: graph)
        display(lintIssues: lintIssues)

        // Update graph
        let reucer = createGraphReducer()
        let updatedGraph = reucer.reduce(model: graph)

        // Generate
        let project = try generator.generateProject(graph: updatedGraph)

        // Write to disk
        try write(project: project, path: path)
    }

    // MARK: -
    
    private func createLinter() -> RecursiveGraphLinter {
        let linter = RecursiveGraphLinter()
        
        // ...
        
        return linter
    }
    
    private func createGraphReducer() -> GraphReducer {
        let reducer = OrderedRecursiveGraphReducer()
        
        // Order matters
        reducer.register(reducer: SwiftLintReducer())
        reducer.register(reducer: ManifestTargetReducer())
        reducer.register(reducer: ManifestProjectReducer())
        reducer.register(reducer: GeneratedSourcesReducer())
        // ...
        
        return reducer
    }
    
    private func loadGraph(at path: AbsolutePath) -> Graph {
        // Manifest > Graph + Models
        //
        // Transforms from `ProjectDescription` > `TuistModel`
        // ...
        return Graph()
    }
    
    private func display(lintIssues: [LintingIssue]) {
        // ...
    }
    
    private func write(project: ProjectDescriptor, path: AbsolutePath) throws {
        try projectWriter.write(descriptor: project, to: path)
    }
}


