import TuistSupport

public enum InfoPlist: Equatable {
    public indirect enum Value: Equatable {
            case string(String)
        //    case integer(Int)
        //    case boolean(Bool)
    
        var value: Any {
            switch self {
            case let .string(string):
                return string
            }
        }
        
        public static func == (lhs: Value, rhs: Value) -> Bool {
            switch (lhs, rhs) {
            case let (.string(lhsString), .string(rhsString)):
                return lhsString == rhsString
            }
        }
    }
    
    case dictionary([String: Value])
    case file(path: AbsolutePath)
    
    public static func == (lhs: InfoPlist, rhs: InfoPlist) -> Bool {
        switch (lhs, rhs) {
        case let (.file(lhsPath), .file(rhsPath)):
            return lhsPath == rhsPath
        case let (.dictionary(lhsDictionary), .dictionary(rhsDictionary)):
            return lhsDictionary == rhsDictionary
        default:
            return false
        }
    }
    
    // MARK: - Public

    public var path: AbsolutePath? {
        switch self {
        case let .file(path):
            return path
        default:
            return nil
        }
    }
}
