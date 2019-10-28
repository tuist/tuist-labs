

# Tuist Design Demo

This is a demo package that illustrates some early concepts we’ve been discussing for the design of Tuist.

# Background

In effort to make Tuist's Xcode generator more re-usable by other tools (e.g. allow custom tooling to be built on top of it) [#205](https://github.com/tuist/tuist/issues/205) was implemented.

The initial idea was to separate out the Xcode project generation logic from the Tuist domain logic by creating a new Module `TuistGenerator`.

This worked for a little while however the nature of the solution adopted didn't scale very well as more feature were added, as such we're now exploring some alternates.

# Issues 

- The responsibilities of `TuistKit` vs `TuistGenerator` were a bit blurry
  - `TuistKit` didn't have knowledge of the dependency graph - as such was unable to apply all the rules in needed to apply
  - As a result `TuistGenerator` was doing more work than simply creating Xcode projects
      - e.g. External calls are made to other systems (e.g. `pod update`, `xcodebuild -resolvePackageDependencies`, etc...) causing side effects.

# Goals

- Improve the overall architecture to allow better modularity 
   - Allow extending Tuist functionality by other tools
   - Allow re-using a subset of the features of Tuist by other tools
   - Have clearer guidelines on module responsibilities
   - Revisit how components are created / wired up to allow extensibility by external tools 
- Making performance a first class requirement as part of the new design
   - Handle large projects
   - Explore parallelization of the generation process

# Next Steps

- Discuss / agree on high level goals
- List out use cases and see if the concepts here address them while keeping the goals stated above in mind
- Discuss how to work towards migrating Tuist to adopt these new concepts

---

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

Additionally the Generator won't perform any external system calls if at all possible (e.g. it won't do `pod update` or `xcodebuild -resolvePackageDependencies`). This ensures it has no side effects.

// TODO

# Use cases to prototype

Manifests:
- [ ] Manifest > Models
- [ ] TuistConfig 

Reducers: 
- [x] Add custom build phases
- [x] Add custom targets
- [x] Add custom projects
- [x] Derived files - Stable / Known files (e.g. InfoPlist - side effect of generating a files + updating model) 
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
