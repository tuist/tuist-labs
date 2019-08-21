import TuistCore

protocol ModelLoading {
    func project(at path: AbsolutePath) throws -> Project
}

protocol GraphLoading {
    func load(using modelLoader: ModelLoading) -> Graph
}
