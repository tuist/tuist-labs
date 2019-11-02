import Foundation
import ProjectDescription
import TuistShared
import TuistSupport

struct ProjectManifest {
    var path: AbsolutePath
    var manifest: ProjectDescription.Project
}

struct Manifests {
    var projects: [ProjectManifest]
}

/// Those are client specific models
/// 
/// they contain both `Graph` which is a Tuist shared model
/// as well as `Manifests` which is a client specific model
struct Models {
    var graph: Graph
    var manifests: Manifests
}

/// Loads all manifests by traversing any `.project` dependencies
protocol GraphManifestLoader {
    func load(at path: AbsolutePath) -> Manifests
}
