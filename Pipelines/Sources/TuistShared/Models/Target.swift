
import Foundation
import TuistSupport

public struct Target: Equatable {
    public var name: String
    public var sources: [AbsolutePath]
    public var actions: [TargetAction]
    public var infoPlist: InfoPlist?
    
    public init(name: String,
                infoPlist: InfoPlist? = nil,
                sources: [AbsolutePath] = [],
                actions: [TargetAction] = []) {
        self.name = name
        self.sources = sources
        self.actions = actions
    }
}
