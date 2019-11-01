
import Foundation
import TuistSupport

public struct Target: Equatable {
    public var name: String
    public var sources: [AbsolutePath]
    
    public init(name: String,
                sources: [AbsolutePath] = []) {
        self.name = name
        self.sources = sources
    }
}
