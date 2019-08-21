
public struct GenerationOptions {
    public var swiftLint: Bool = false
    public var manifestTarget: Bool = true
}

public struct TuistConfig {
    public var generationOptions: GenerationOptions
}
