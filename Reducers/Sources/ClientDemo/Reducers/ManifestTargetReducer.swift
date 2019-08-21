
import Foundation
import TuistCore
import TuistModels

class ManifestTargetReducer: ProjectModelReducer {
    func reduce(model: Project) -> Project {
        var updated = model
        let target = Target(name: "Manifest_\(model.name)")
        updated.targets.append(target)
        return updated
    }
}
