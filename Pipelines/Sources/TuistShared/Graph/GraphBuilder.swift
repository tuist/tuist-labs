
import Foundation
import TuistSupport

/// Constructs a graph given a set of objects
public protocol GraphBuilding {
    func build(workspace: Workspace?, projects: [Project]) -> Graph
}
