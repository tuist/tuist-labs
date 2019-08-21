
import TuistCore

public protocol ProjectDescriptorWriting {
    func write(descriptor: ProjectDescriptor, to path: AbsolutePath) throws
}

public protocol WorkspaceDescriptorWriting {
    func write(descriptor: WorkspaceDescriptor, to path: AbsolutePath) throws
}
