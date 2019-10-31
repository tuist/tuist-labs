
import Foundation
import TuistCore
import TuistModels
import TuistGenerator

class InfoPlistReducer: ProjectModelReducer {
    private let targets: [InfoPlistGenerator.TargetIdentifier]
    
    init(targets: [InfoPlistGenerator.TargetIdentifier]) {
        self.targets = targets
    }
    
    func reduce(model: Project) -> Project {
        var updated = model
        updated.targets = model.targets.map { target in
            return reduce(target: target, at: model.path)
        }
        return updated
    }
    
    private func reduce(target: Target, at path: AbsolutePath) -> Target {
        if targets.contains(where: { $0.path == path && $0.target == target.name }) {
            var updatedTarget = target
            updatedTarget.infoPlist = AbsolutePath("..")
            return updatedTarget
        }
        return target
    }
}
