import ProjectDescription
import TuistCore

protocol ManifestLoading {
    func loadProject(at path: AbsolutePath) throws -> Project
}
