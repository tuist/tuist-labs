
import Foundation
import TuistSupport

public enum SideEffect: Equatable {
    
    case createFile(File)
    case command(Command)
    
    public struct File: Equatable {
        public var path: AbsolutePath
        public var content: Data?
        
        public init(path: AbsolutePath, content: Data? = nil) {
            self.path = path
            self.content = content
        }
    }
    
    public struct Command: Equatable {
        public var arguments: [String]
        init(arguments: [String]) {
            self.arguments = arguments
        }
    }

}
