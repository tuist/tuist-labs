import XCTest
import TuistShared
import TuistSupport
@testable import TuistTransformers

class InfoPlistTransformerTests: XCTestCase {
    var subject: InfoPlistTransformer!
    
    override func setUp() {
        subject = InfoPlistTransformer()
    }
    
    // MARK: - Tests
    
    func test_transform_modelDoesNotUpdate() throws {
        // Given
        let model = Target(name: "Target",
                           infoPlist: .file(path: AbsolutePath("/Foo/Bar")))
        // When
        let result = try subject.transform(model: model)
        
        // Then
        XCTAssertEqual(result.model.infoPlist, .file(path: AbsolutePath("/Foo/Bar")))
    }
    
    func test_transform_noSideEeffects() throws {
        // Given
        let model = Target(name: "Target",
                           infoPlist: .file(path: AbsolutePath("/Foo/Bar")))
        // When
        let result = try subject.transform(model: model)
        
        // Then
        XCTAssertTrue(result.sideEffects.isEmpty)
    }
    
    func test_transform_modelUpdates() throws {
        // Given
        let model = Target(name: "Target",
                           infoPlist: .dictionary(["A": .string("B")]))
        // When
        let result = try subject.transform(model: model)
        
        // Then
        XCTAssertEqual(result.model.infoPlist, .file(path: AbsolutePath("/project/Info.plist")))
    }
    
    func test_transform_sideEffect() throws {
        // Given
        let model = Target(name: "Target",
                           infoPlist: .dictionary(["A": .string("B")]))
        // When
        let result = try subject.transform(model: model)
        
        // Then
        XCTAssertEqual(result.sideEffects.map(createFilePath), [
            AbsolutePath("/project/Info.plist")
        ])
    }
    
    // MARK: - Helpers
    private func createFilePath(in sideEffect: SideEffect) -> AbsolutePath? {
        switch sideEffect.action {
        case let .createFile(file):
            return file.path
        default:
            return nil
        }
    }
}
