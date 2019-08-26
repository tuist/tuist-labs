
import Foundation
import TuistCore
import TuistModels

class SwiftLintWithConfigReducer: ProjectModelReducer {
    private let tuistConfigLoader: TuistConfigLoader
    
    init(tuistConfigLoader: TuistConfigLoader) {
        self.tuistConfigLoader = tuistConfigLoader
    }
    
    func reduce(model: Project) -> Project {
        guard let config = try? tuistConfigLoader.loadConfig(at: model.path),
                config.generationOptions.swiftLint else {
            return model
        }
        
        var updated = model
        let swiftLint = ScriptBuildPhase(name: "SwiftLint", script: "swiftlint")
        updated.targets = updated.targets.map { target in
            var updated = target
            updated.buildPhases.append(.script(swiftLint))
            return updated
        }
        
        return updated
    }
}
