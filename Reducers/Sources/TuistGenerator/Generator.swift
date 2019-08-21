import TuistModels

public struct ProjectDescriptor {
    public var xcodeProj: XcodeProj
    public var schemes: [XCScheme]
}

public struct WorkspaceDescriptor {
    public var xcworkspace: XCWorkspace
    public var projects: [ProjectDescriptor]
}

/// Generaotr
///
///   Graph > Descriptors
///
/// Clients can chose to write to disk or to analyze the descriptors without any file io
public protocol Generating {
    func generateProject(graph: Graph) throws -> ProjectDescriptor
    func generateProjectWorkspace(graph: Graph) throws -> WorkspaceDescriptor
    func generateWorkspace(graph: Graph) throws -> WorkspaceDescriptor
}
