import Foundation

public enum Product {
    case app
    case framework
}

public enum Platform {
    case iOS
    case macOS
}

public struct Target {
    public var name: String
    public var platform: Platform
    public var product: Product
    public var sources: [String]
    public var actions: [TargetAction]
    
    public init(name: String,
                platform: Platform,
                product: Product,
                sources: [String] = [],
                actions: [TargetAction] = []) {
        self.name = name
        self.platform = platform
        self.product = product
        self.sources = sources
        self.actions = actions
    }
}
