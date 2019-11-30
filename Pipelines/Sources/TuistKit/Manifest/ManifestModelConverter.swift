
import Foundation
import ProjectDescription
import TuistShared
import TuistSupport

struct ManifestModelConverter {
    private let path: AbsolutePath
    init(path: AbsolutePath) {
        self.path = path
    }
  
    // Conversion as transformation -> does not lead to any real benefist, this probably should stay as simple conversion
//    func convert(manifest: ProjectDescription.Project) -> Transformation<TuistShared.Project> {
//        let targetsTransformations = manifest.targets.map(convert)
//        let project: TuistShared.Project = .init(path: path,
//                                                 name: manifest.name,
//                                                 targets: targetsTransformations.map { $0.model })
//        return Transformation(model: project, sideEffects: targetsTransformations.flatMap { $0.sideEffects })
//    }
//
//    func convert(manifest: ProjectDescription.Target) -> Transformation<TuistShared.Target> {
//        let target: TuistShared.Target = .init(name: manifest.name,
//                                               sources: manifest.sources.map(AbsolutePath.init),
//                                               actions: manifest.actions.map(convert))
//        return Transformation(model: target,
//                              sideEffects: [SideEffect(action: .createFile(SideEffect.File(path: AbsolutePath("/InfoPlist"))),
//                                                       category: .preGeneration)])
//    }
    
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
