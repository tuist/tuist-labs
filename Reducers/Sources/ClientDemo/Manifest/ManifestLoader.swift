import ProjectDescription
import TuistCore

enum Manifest {
    case project
    case tuistConfig
}

protocol ManifestLoading {
    func manifests(at path: AbsolutePath) throws -> [Manifest]
    func loadProject(at path: AbsolutePath) throws -> Project
    func loadConfig(at path: AbsolutePath) throws -> TuistConfig
}
