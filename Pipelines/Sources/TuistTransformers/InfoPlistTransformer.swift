
import Foundation
import TuistShared
import TuistSupport

public class InfoPlistTransformer: TargetTransforming {
    public func transform(model: Target) throws -> Transformation<Target> {
        guard let dictionary = infoPlistDictionary(in: model) else {
            return Transformation(model: model)
        }
        let data = try PropertyListSerialization.data(fromPropertyList: dictionary.toAny(),
                                                       format: .xml,
                                                       options: 0)
        
        let infoPlistPath = AbsolutePath("/project/Info.plist")
        let infoPlistFile = SideEffect.File(path: infoPlistPath, content: data)
        
        var updated = model
        updated.infoPlist = .file(path: infoPlistPath)
        return Transformation(model: updated,
                              sideEffects: [
                                SideEffect(action: .createFile(infoPlistFile),
                                           category: .preGeneration)
        ])
    }
    
    private func infoPlistDictionary(in model: Target) -> [String: InfoPlist.Value]? {
        switch model.infoPlist {
        case let .dictionary(dictionary):
            return dictionary
        default:
            return nil
        }
    }
    
}

private extension Dictionary where Key == String, Value == InfoPlist.Value {
    func toAny() -> [String: Any] {
        return mapValues { $0.toAny() }
    }
}

private extension InfoPlist.Value {
    func toAny() -> Any {
        switch self {
        case let .string(string):
            return string
        }
    }
}
