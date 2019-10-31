import Foundation
import TuistCore

public class InfoPlistGenerator {
    public struct TargetIdentifier {
        public var path: AbsolutePath
        public var target: String
        public init(path: AbsolutePath, target: String) {
            self.path = path
            self.target = target
        }
    }
    
    private let targets: [TargetIdentifier]
    public init(targets: [TargetIdentifier]) {
        self.targets = targets
    }
    
    public func generate() {
        // ...
    }
}
