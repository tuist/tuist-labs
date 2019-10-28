
// Note: This is a temporary placeholder of `Basic.AbsolutePath` from SwiftPM 
// for demo purposes

public struct AbsolutePath: Equatable, Hashable {
    public init() {
        
    }
    
    public init(_ stringPath: String) {
        // ...
    }
    
    public var isRoot: Bool {
        // stub
        return true
    }
    public var parentDirectory: AbsolutePath {
        // stub
        return AbsolutePath()
    }
}
