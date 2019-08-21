
import Foundation
import TuistCore
import TuistModels

class ManifestProjectReducer: GraphReducer {
    func reduce(model: Graph) -> Graph {
        var updated = model
        let project = Project(name: "TuistManifests")
        updated.projects.append(project)
        return updated
    }
}
