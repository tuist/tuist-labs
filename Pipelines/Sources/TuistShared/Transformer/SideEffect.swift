
import Foundation
import TuistSupport

public struct SideEffect: Equatable {
    public var action: Action
    public var category: Category
    
    public init(action: SideEffect.Action, category: SideEffect.Category) {
        self.action = action
        self.category = category
    }
    
    // MARK: -
    
    public enum Action: Equatable {
        case createFile(File)
        case command(Command)
    }
    
    public enum Category: Equatable {
        case preGeneration
        case postGeneration
    }
    
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
