
import Foundation
import TuistCore
import TuistModels

class SwiftLintReducer: TargetModelReducer {
    func reduce(model: Target) -> Target {
        var updated = model
        let swiftLint = ScriptBuildPhase(name: "SwiftLint", script: "swiftlint")
        updated.buildPhases.append(.script(swiftLint))
        return updated
    }
}
