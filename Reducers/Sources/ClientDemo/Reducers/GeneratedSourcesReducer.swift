//
//  File.swift
//  
//
//  Created by Wridan, Kassem on 28/10/2019.
//

import Foundation
import TuistCore
import TuistModels

class GeneratedSourcesReducer: TargetModelReducer {
    func reduce(model: Target) -> Target {
        var updated = model
        updated.sources.append(AbsolutePath("Generated/MyGeneratedEnums.swift"))
        return updated
    }
}
