

# Tuist Design Demo

This is a demo package that illustrates some early concepts we’ve been discussing for the design of Tuist.

# Concepts


## Reducers

For this concept a few assumptions were made:

- Models are value types
- Graph is a model type
- Graph is the input to the generator

Clients of the library can apply reducers (be it common ones or their custom ones) by leveraging:

- `RecursiveGraphReducer`: A reducer where `GraphReducer`, `ProjectModelReducer` and `TargetModelReducer` can be registered and get applied recursively on a graph
- `OrderedRecursiveGraphReducer`: The same as  `RecursiveGraphReducer` except it preserves order of registration at the cost of inefficient graph traversals

e.g.

```swift
let reducer = OrderedRecursiveGraphReducer()

// Order matters
reducer.register(reducer: SwiftLintReducer())
reducer.register(reducer: ManifestTargetReducer())
// ...

let updatedGraph = reducer.reduce(graph)
```

## Separate linting process

Having a separate linting process would allow the graph to be linted without needing to generate the project - i.e. could allow for a `tuist lint` command that can perform several linting steps.

Similarly to reducers, clients of the library can leverage common or custom linters.

// TODO

## Generator produces descriptors

The generator component will be responsible for transforming `Graph` into `Descriptor`s - that is it won't necessarily write to disk on its own by default, but allows clients to examine the generated `XcodeProj` classes for any final tweaks or analysis (e.g. testing).

// TODO

# Use cases to prototype

Manifests:
- [ ] Manifest > Models
- [ ] TuistConfig 

Reducers: 
- [x] Add custom build phases
- [x] Add custom targets
- [x] Add custom projects
- [ ] Derived files - Stable / Known files (e.g. InfoPlist - side effect of generating a files + updating model) 
- [ ] Derived files - Unstable / Unknown files (e.g. Resources - side effect of generating a files + updating model)
- [ ] Control reducers via tuist config 
   - Each reducer could consult the tuist config at the appropriate path
   - Or selectively register reducers based on one tuist config

Linters:
- [ ] Existing `TuistGenerator` linters
- [ ] Custom linter
- [ ] Manifest vs model linters

Generator descriptors:
- [ ] workspace descriptors
- [ ] scehemes
