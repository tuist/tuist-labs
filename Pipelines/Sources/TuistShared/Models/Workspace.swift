import Foundation

public struct Workspace {
    public var name: String
    public var projects: [Project]
    
    public init(name: String, projects: [Project]) {
        self.name = name
        self.projects = projects
    }
}

