import XCTest
import TuistSupport
@testable import TuistShared

class OrderedGraphLinterTests: XCTestCase {
    var subject: OrderedGraphLinter!
    
    override func setUp() {
        subject = OrderedGraphLinter()
    }
    
    func test_lint_projectCanNotHaveName() {
        // Given
        let graph = createGraph(projects: [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "A_T1")
            ])
        ])
        
        subject.register(linter: customProjectLinter())
        
        // When
        let result = subject.lint(model: graph)
        
        // Then
        XCTAssertEqual(result, [LintingIssue(reason: "Projects can not be called A", severity: .error)])
    }
    
    func test_lint_targetHasNoDuplicateDependencies() {
        // Given
        let dependency = Dependency.target(name: "B")
        let graph = createGraph(projects: [
            Project(path: AbsolutePath("/project"),
                    name: "A",
                    targets: [
                        Target(name: "A_T1", dependencies: [dependency, dependency])
            ])
        ])
        
        subject.register(linter: duplicateDependencyTargetLinter())
        
        // When
        let result = subject.lint(model: graph)
        
        // Then
        XCTAssertEqual(result, [LintingIssue(reason: "Target has duplicate '\(dependency)' dependency specified", severity: .warning)])
    }
    
    private func customProjectLinter() -> ProjectLinting {
        class Linter: ProjectLinting {
            func lint(model: Project) -> [LintingIssue] {
                var issues: [LintingIssue] = []
                
                if model.name == "A" {
                    issues.append(LintingIssue(reason: "Projects can not be called A", severity: .error))
                }
                
                return issues
            }
        }
        return Linter()
    }
    
    private func duplicateDependencyTargetLinter() -> TargetLinting {
        class Linter: TargetLinting {
            func lint(model: Target) -> [LintingIssue] {
                typealias Occurence = Int
                var seen: [Dependency: Occurence] = [:]
                model.dependencies.forEach { seen[$0, default: 0] += 1 }
                let duplicates = seen.enumerated().filter { $0.element.value > 1 }
                return duplicates.map {
                    .init(reason: "Target has duplicate '\($0.element.key)' dependency specified", severity: .warning)
                }
            }
        }
        
        return Linter()
    }
    
    private func createGraph(projects: [Project] = []) -> Graph {
        return Graph(projects: projects)
    }
}
    
