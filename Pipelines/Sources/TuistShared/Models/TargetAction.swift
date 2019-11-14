import TuistSupport

public struct TargetAction: Equatable {
    public enum Order: String {
        case pre
        case post
    }
    
    public let name: String
    public let tool: String?
    public let path: AbsolutePath?
    public let order: Order
    public let arguments: [String]
    public let inputPaths: [AbsolutePath]
    public let inputFileListPaths: [AbsolutePath]
    public let outputPaths: [AbsolutePath]
    public let outputFileListPaths: [AbsolutePath]
    
    public init(name: String,
            order: Order,
            tool: String? = nil,
            path: AbsolutePath? = nil,
            arguments: [String] = [],
            inputPaths: [AbsolutePath] = [],
            inputFileListPaths: [AbsolutePath] = [],
            outputPaths: [AbsolutePath] = [],
            outputFileListPaths: [AbsolutePath] = []) {
        self.name = name
        self.order = order
        self.tool = tool
        self.path = path
        self.arguments = arguments
        self.inputPaths = inputPaths
        self.inputFileListPaths = inputFileListPaths
        self.outputPaths = outputPaths
        self.outputFileListPaths = outputFileListPaths
    }
}
