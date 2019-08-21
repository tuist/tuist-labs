import TuistCore

public struct Graph: Equatable {
    public struct TargetNode: Equatable {
        var name: String
        var path: AbsolutePath
        var dependencies: [TargetNode]
    }
    
    public var entryNodes: [TargetNode]
    public var projects: [Project]
    // ...
    
    public init(entryNodes: [TargetNode] = [],
                projects: [Project] = []) {
        self.entryNodes = entryNodes
        self.projects = projects
        // ...
    }
    
    public func project(at path: AbsolutePath) throws -> Project {
        fatalError("Not yet implemented")
    }
    
    public func target(name: String, at path: AbsolutePath) throws -> Target {
        fatalError("Not yet implemented")
    }
}
