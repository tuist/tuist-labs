import XCTest
import TuistModels

class RecursiveGraphReducerTests: XCTestCase {
    var subject: RecursiveGraphReducer!
    
    override func setUp() {
        subject = RecursiveGraphReducer()
    }
    
    func test_reduce_projectReducer() {
        // Given
        let graph = createGraph(projects: [
            Project(name: "A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
        
        subject.register(reducer: projectNameReducer())
        
        // When
        let result = subject.reduce(model: graph)
        
        // Then
        XCTAssertEqual(result.projects, [
            Project(name: "Updated_A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
    }
    
    func test_reduce_targetReducer() {
        // Given
        let graph = createGraph(projects: [
            Project(name: "A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
        
        subject.register(reducer: targetNameReducer())
        
        // When
        let result = subject.reduce(model: graph)
        
        // Then
        XCTAssertEqual(result.projects, [
            Project(name: "A",
                    targets: [
                        Target(name: "Updated_A_T1")
            ])
        ])
    }
    
    func test_reduce_projectAndTargetReducer() {
        // Given
        let graph = createGraph(projects: [
            Project(name: "A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
        
        subject.register(reducer: targetNameReducer())
        subject.register(reducer: projectNameReducer())
        
        // When
        let result = subject.reduce(model: graph)
        
        // Then
        XCTAssertEqual(result.projects, [
            Project(name: "Updated_A",
                    targets: [
                        Target(name: "Updated_A_T1")
            ])
        ])
    }
    
    func test_reduce_reducerOrderDoesNotMatter() {
        // Given
        let graph = createGraph(projects: [
            Project(name: "A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
        
        let subject = RecursiveGraphReducer()
        subject.register(reducer: targetNameReducer())
        subject.register(reducer: customTargetAddingReducer())
        
        let reversedSubject = RecursiveGraphReducer()
        reversedSubject.register(reducer: customTargetAddingReducer())
        reversedSubject.register(reducer: targetNameReducer())
        
        // When
        let resultA = subject.reduce(model: graph)
        let resultB = reversedSubject.reduce(model: graph)
        
        // Then
        XCTAssertEqual(resultA, resultB)
    }
    
    // MARK: - Helpers
    
    func projectNameReducer() -> ProjectModelReducer {
        class Reducer: ProjectModelReducer {
            func reduce(model: Project) -> Project {
                var updated = model
                updated.name = "Updated_\(model.name)"
                return updated
            }
        }
        
        return Reducer()
    }
    
    func targetNameReducer() -> TargetModelReducer {
        class Reducer: TargetModelReducer {
            func reduce(model: Target) -> Target {
                var updated = model
                updated.name = "Updated_\(model.name)"
                return updated
            }
        }
        
        return Reducer()
    }
    
    func customTargetAddingReducer() -> ProjectModelReducer {
        class Reducer: ProjectModelReducer {
            func reduce(model: Project) -> Project {
                var updated = model
                let customTarget = Target(name: "CustomTarget")
                updated.targets.append(customTarget)
                return updated
            }
        }
        
        return Reducer()
    }
    
    func createGraph(projects: [Project] = []) -> Graph {
        return Graph(projects: projects)
    }

        static var allTests = [
            ("test_reduce_projectReducer", test_reduce_projectReducer),
            ("test_reduce_targetReducer", test_reduce_targetReducer),
            ("test_reduce_projectAndTargetReducer", test_reduce_projectAndTargetReducer),
            ("test_reduce_reducerOrderDoesNotMatter", test_reduce_reducerOrderDoesNotMatter),
    ]

}
