
import Foundation
import TuistSupport

public struct Project: Equatable {
    public var path: AbsolutePath
    public var name: String
    public var targets: [Target]
    
    public init(path: AbsolutePath,
                name: String,
                targets: [Target]) {
        self.path = path
        self.name = name
        self.targets = targets
    }
}
