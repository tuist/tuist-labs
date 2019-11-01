
import Foundation
import TuistSupport
import ProjectDescription

protocol ManifestLoading {
    func loadProject(at path: AbsolutePath) throws -> Project
}
