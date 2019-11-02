
import Foundation
import ProjectDescription
import TuistShared
import TuistSupport

struct ManifestModelConverter {
    private let path: AbsolutePath
    init(path: AbsolutePath) {
        self.path = path
    }
    
    func convert(manifest: ProjectDescription.Project) -> TuistShared.Project {
        return .init(path: path,
                     name: manifest.name,
                     targets: manifest.targets.map(convert))
    }
    
    func convert(manifest: ProjectDescription.Target) -> TuistShared.Target {
        return .init(name: manifest.name,
                     sources: manifest.sources.map(AbsolutePath.init))
    }
}
