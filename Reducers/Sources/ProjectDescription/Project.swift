
public struct Project {
    var name: String
    var target: [Target]
    // ...
}

public struct Target {
    var name: String
    var sources: [String] // Accepts glob patterns
}