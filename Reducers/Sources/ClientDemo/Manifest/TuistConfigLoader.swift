
import Foundation
import TuistCore
import ProjectDescription

protocol TuistConfigLoading {
    func loadConfig(at path: AbsolutePath) throws -> TuistConfig?
}

class TuistConfigLoader: TuistConfigLoading {
    private let manifestLoader: ManifestLoading
    private var configCache: [AbsolutePath: TuistConfig] = [:]
    
    init(manifestLoader: ManifestLoading) {
        self.manifestLoader = manifestLoader
    }
    
    /// Recursively traverse parent directories to find a TuistConfig
    func loadConfig(at path: AbsolutePath) throws -> TuistConfig? {
        if let cached = configCache[path] {
            return cached
        }
        
        if try manifestLoader.manifests(at: path).contains(.tuistConfig) {
            let config = try manifestLoader.loadConfig(at: path)
            configCache[path] = config
            return config
        }
        
        guard !path.isRoot else {
            return nil
        }
        
        return try loadConfig(at: path.parentDirectory)
    }
}
