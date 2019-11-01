
import Foundation

public struct Graph: Equatable {
    public var projects: [Project]
    public init(projects: [Project]) {
        self.projects = projects
    }
}
