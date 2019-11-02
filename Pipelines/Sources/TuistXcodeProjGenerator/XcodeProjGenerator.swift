
import Foundation
import TuistShared

public struct ProjectDescriptor {
    public var xcodeProj: XcodeProj
    public var schemes: [XCScheme]
}

public struct WorkspaceDescriptor {
    public var xcworkspace: XCWorkspace
    public var projects: [ProjectDescriptor]
}

public protocol XcodeProjGenerating {
    func generateProject(grap: Graph) -> ProjectDescriptor
    func generateWorkspace(grap: Graph) -> WorkspaceDescriptor
}
