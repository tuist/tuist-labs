import Foundation

public protocol SideEffectActionHandling {
    func handle(sideEffects: [SideEffect.Action]) throws
}

class SideEffectActionHandler {
    func handle(sideEffects: [SideEffect.Action]) throws {
        sideEffects.forEach {
            switch $0 {
            case let .createFile(file):
                handle(sideEffect: file)
            case let .command(command):
                handle(sideEffect: command)
            }
        }
    }
    
    private func handle(sideEffect: SideEffect.File) {
        // ...
    }
    
    private func handle(sideEffect: SideEffect.Command) {
        // ...
    }
}
