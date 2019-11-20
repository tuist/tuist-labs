import TuistSupport

public enum Dependency: Equatable, Hashable {
    case target(name: String)
    case project(target: String, path: AbsolutePath)
//    case framework(path: AbsolutePath)
//    case library(path: AbsolutePath, publicHeaders: AbsolutePath, swiftModuleMap: AbsolutePath?)
//    case package(product: String)
//    case sdk(name: String, status: SDKStatus)
//    case cocoapods(path: AbsolutePath)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .target(name: name):
            hasher.combine(name)
        case let .project(target: target, path: path):
            hasher.combine(target)
            hasher.combine(path)
        }
    }
}
