
public enum InfoPlist: Equatable {
    case file(path: String)
    case `default`
}

public struct Project {
    public var name: String
    public var targets: [Target]
    // ...
}

public struct Target {
    public var name: String
    public var infoPlist: InfoPlist
    public var sources: [String] // Accepts glob patterns
}
