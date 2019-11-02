
import Foundation

public struct Project {
    public var name: String
    public var targets: [Target]
    
    public init(name: String,
                targets: [Target] = []) {
        self.name = name
        self.targets = targets
    }
}
