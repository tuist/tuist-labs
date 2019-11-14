public struct TargetAction {
    public enum Order: String {
        case pre
        case post
    }
    
    public let name: String
    public let tool: String?
    public let path: String?
    public let order: Order
    public let arguments: [String]
    public let inputPaths: [String]
    public let inputFileListPaths: [String]
    public let outputPaths: [String]
    public let outputFileListPaths: [String]
    
    public init(name: String,
                order: Order,
                tool: String? = nil,
                path: String? = nil,
                arguments: [String] = [],
                inputPaths: [String] = [],
                inputFileListPaths: [String] = [],
                outputPaths: [String] = [],
                outputFileListPaths: [String] = []) {
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
