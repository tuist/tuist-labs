
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
                     sources: manifest.sources.map(AbsolutePath.init),
                     actions: manifest.actions.map(convert))
    }
    
    func convert(manifest: ProjectDescription.TargetAction) -> TuistShared.TargetAction {
        let order: TuistShared.TargetAction.Order
        switch manifest.order {
        case .pre:
            order = .pre
        case .post:
            order = .post
        }
        
        return TuistShared.TargetAction(name: manifest.name,
                                        order: order,
                                        tool: manifest.tool,
                                        path: manifest.path.flatMap(AbsolutePath.init),
                                        arguments: manifest.arguments,
                                        inputPaths: manifest.inputPaths.map(AbsolutePath.init),
                                        inputFileListPaths: manifest.inputFileListPaths.map(AbsolutePath.init),
                                        outputPaths: manifest.outputPaths.map(AbsolutePath.init),
                                        outputFileListPaths: manifest.outputFileListPaths.map(AbsolutePath.init))
    }
}
