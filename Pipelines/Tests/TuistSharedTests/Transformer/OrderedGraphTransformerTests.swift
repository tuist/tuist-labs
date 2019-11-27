import XCTest
import TuistSupport
@testable import TuistShared

class OrderedGraphTransformerTests: XCTestCase {
    var subject: OrderedGraphTransformer!
    
    override func setUp() {
        subject = OrderedGraphTransformer()
    }
    
    func test_transform_projectTransformer() throws {
        // Given
        let graph = createGraph(projects: [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
        
        subject.register(transformer: projectNameTransformer())
        
        // When
        let result = try subject.transform(model: graph)
        
        // Then
        XCTAssertEqual(result.model.projects, [
            Project(path: AbsolutePath("/project"),
                    name: "Updated_A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
    }
    
    func test_transform_targetTransformer() throws {
        // Given
        let graph = createGraph(projects: [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
        
        subject.register(transformer: targetNameTransformer())
        
        // When
        let result = try subject.transform(model: graph)
        
        // Then
        XCTAssertEqual(result.model.projects, [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "Updated_A_T1")
            ])
        ])
    }
    
    func test_transform_projectAndTargetTransformer() throws {
        // Given
        let graph = createGraph(projects: [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
        
        subject.register(transformer: targetNameTransformer())
        subject.register(transformer: projectNameTransformer())
        
        // When
        let result = try subject.transform(model: graph)
        
        // Then
        XCTAssertEqual(result.model.projects, [
            Project(path: AbsolutePath("/project"),
                    name: "Updated_A",
                    targets: [
                        Target(name: "Updated_A_T1")
            ])
        ])
    }
    
    func test_transform_addTargetBeforeRename() throws {
        // Given
        let graph = createGraph(projects: [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
        
        subject.register(transformer: customTargetAddingTransformer())
        subject.register(transformer: targetNameTransformer())
        
        // When
        let result = try subject.transform(model: graph)
        
        // Then
        XCTAssertEqual(result.model.projects, [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "Updated_A_T1"),
                        Target(name: "Updated_CustomTarget"),
            ])
        ])
    }
    
    func test_transform_renameBeforeAddingTargets() throws {
        // Given
        let graph = createGraph(projects: [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
        
        subject.register(transformer: targetNameTransformer())
        subject.register(transformer: customTargetAddingTransformer())
        
        // When
        let result = try subject.transform(model: graph)
        
        // Then
        XCTAssertEqual(result.model.projects, [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "Updated_A_T1"),
                        Target(name: "CustomTarget"),
            ])
        ])
    }
    
    func test_transform_sideEffects() throws {
        // Given
        let transformer = ConstantsSourceGeneratorTransformer()
        let graph = createGraph(projects: [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
        
        subject.register(transformer: transformer)
        
        // When
        let result = try subject.transform(model: graph)
        
        // Then
        XCTAssertEqual(result.model.projects.flatMap { $0.targets }, [
            Target(name: "A_T1",
                   sources: [
                    AbsolutePath("/project/Generated/Constants.swift"),
            ])
        ])
        
        let expectedFile = SideEffect.File(path: AbsolutePath("/project/Generated/Constants.swift"),
                                           content: transformer.constantsFileData())
        XCTAssertEqual(result.sideEffects, [
            SideEffect(action: .createFile(expectedFile), category: .preGeneration)
        ])
    }
    
    func test_transform_targetActions() throws {
        // Given
        let graph = createGraph(projects: [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "A_T1"),
                        Target(name: "B_T1"),
            ])
        ])
        
        subject.register(transformer: targetActionTransformer())
        
        // When
        let result = try subject.transform(model: graph)
        
        // Then
        let targets = result.model.projects.flatMap { $0.targets }
        XCTAssertEqual(targets.map { "Action_\($0.name)" },
                       targets.flatMap { $0.actions.map { $0.name } })
    }
    
    // MARK: - Helpers
    
    private func generateFilesTransformer() -> TargetTransforming {
        class Transformer: TargetTransforming {
            func transform(model: Target) -> Transformation<Target> {
                let command = SideEffect.Command(arguments: ["swiftgen"])
                return Transformation(model: model, sideEffects: [SideEffect(action: .command(command),
                                                                             category: .preGeneration)])
            }
        }
        
        return Transformer()
    }
    
    private func targetActionTransformer() -> TargetTransforming {
        class Transformer: TargetTransforming {
            func transform(model: Target) -> Transformation<Target> {
                var updated = model
                updated.actions.append(TargetAction(name: "Action_\(model.name)", order: .pre))
                return Transformation(model: updated)
            }
        }
        
        return Transformer()
    }
    
    private func projectNameTransformer() -> ProjectTransforming {
        class Transformer: ProjectTransforming {
            func transform(model: Project) -> Transformation<Project> {
                var updated = model
                updated.name = "Updated_\(model.name)"
                return Transformation(model: updated)
            }
        }
        
        return Transformer()
    }
    
    private func targetNameTransformer() -> TargetTransforming {
        class Transformer: TargetTransforming {
            func transform(model: Target) -> Transformation<Target> {
                var updated = model
                updated.name = "Updated_\(model.name)"
                return Transformation(model: updated)
            }
        }
        
        return Transformer()
    }
    
    private func customTargetAddingTransformer() -> ProjectTransforming {
        class Transformer: ProjectTransforming {
            func transform(model: Project) -> Transformation<Project> {
                var updated = model
                let customTarget = Target(name: "CustomTarget")
                updated.targets.append(customTarget)
                return Transformation(model: updated)
            }
        }
        
        return Transformer()
    }
    
    private class ConstantsSourceGeneratorTransformer: TargetTransforming {
        func transform(model: Target) -> Transformation<Target> {
            
            // TODO: Having project path would be useful here
            let filePath = AbsolutePath("/project/Generated/Constants.swift")
            let file = SideEffect.File(path: filePath,
                                       content: constantsFileData())
            
            var updated = model
            updated.sources.append(filePath)
            return Transformation(model: updated,
                                  sideEffects: [
                                    SideEffect(action: .createFile(file),
                                               category: .preGeneration)
            ])
        }
        
        func constantsFileData() -> Data? {
            let content = """
              public struct Constants {
                  static let version = "1.0"
              }
              """.data(using: .utf8)
            return content
        }
    }
    
    private func createGraph(projects: [Project] = []) -> Graph {
        return Graph(projects: projects)
    }

    static var allTests = [
        ("test_transform_projectTransformer", test_transform_projectTransformer),
        ("test_transform_targetTransformer", test_transform_targetTransformer),
        ("test_transform_projectAndTargetTransformer", test_transform_projectAndTargetTransformer),
        ("test_transform_addTargetBeforeRename", test_transform_addTargetBeforeRename),
        ("test_transform_renameBeforeAddingTargets", test_transform_renameBeforeAddingTargets),
        ("test_transform_sideEffects", test_transform_sideEffects),
    ]

}
