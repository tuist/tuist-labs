
import Foundation
import TuistSupport

public struct Target: Equatable {
    public var name: String
    public var sources: [AbsolutePath]
    public var actions: [TargetAction]
    
    public init(name: String,
                sources: [AbsolutePath] = [],
                actions: [TargetAction] = []) {
        self.name = name
        self.sources = sources
        self.actions = actions
    }
}
