

# Tuist Design Demo (Pipelines)

This is a demo package that illustrates some early concepts we’ve been discussing for the design of Tuist.

# Background

In effort to make Tuist's Xcode generator more re-usable by other tools (e.g. allow custom tooling to be built on top of it) [#205](https://github.com/tuist/tuist/issues/205) was implemented.

The initial idea was to separate out the Xcode project generation logic from the Tuist domain logic by creating a new Module `TuistGenerator`.

This worked for a little while however the nature of the solution adopted didn't scale very well as more feature were added, as such we're now exploring some alternates.

# Issues 

- The responsibilities of `TuistKit` vs `TuistGenerator` were a bit blurry
  - What goes where?
  - `TuistKit` didn't have knowledge of the dependency graph - as such was unable to apply all the rules in needed to apply
  - As a result `TuistGenerator` was doing more work than simply creating Xcode projects
      - e.g. External calls are made to other systems (e.g. `pod update`, `xcodebuild -resolvePackageDependencies`, etc...) causing side effects.
- Model translation from manifest got quite messy (large model loader)

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

- [x] Discuss / agree on high level goals
- [ ] List out use cases and see if the concepts here address them while keeping the goals stated above in mind
- [ ] Prototype use cases
- [ ] Discuss how to work towards migrating Tuist to adopt these new concepts

---

# Concepts

## Pipelines

The generation process can be composed into a pipeline of configurable steps.

A series of `Transformer`s can be registered which can transform the models ahead of `XcodeProj` model generation

- Load Manifest > Models
- Register transfomers
- Run transformers
- Run pre-generation side effects
- Run XcodeProj generator
- Run post-generation side effects

// TODO [Diagram from discussion]

## Models

Models are value types and include:

- `Graph`
    - `Project`
        - `Target`
            - ...
        - `Scheme`

Those will be closer to XcodeProj models than the public manifests

## Transformers

A `Transformer` can:
- Transform models
- Add side effects

Clients of the library can register transformers (be it common ones or their custom ones) by leveraging:

e.g.

```swift
let transformers = OrderedTransformers()

// Order matters
transformers.register(transformer: SwiftLintTransformer())
transformers.register(transformer: ManifestTargetTransformer())
transformers.register(transformer: MyCustomTransformer())
// ...

let updatedGraph = transformers.transform(graph)
```

// TODO Transformer API

## Side Effects

Side effects include:
- Run a command
- Create a file

```swift
enum SideEffect {
    struct File {
        var path: AbsolutePath
        var content: String
    }

    struct Command {
        var arguments: [String]
    }

    case command(Command)
    case createFile(File)
}
```

## Transformer Rules

- Transformers can't add projects to an existing graph however they can add new graphs
- ...

## Separate linting process

Having a separate linting process would allow the graph to be linted without needing to generate the project - i.e. could allow for a `tuist lint` command that can perform several linting steps.

Similarly to transformers, clients of the library can leverage common or custom linters.

// TODO

## XcodeProj Generator produces descriptors

The XcodeProj generator component will be responsible for transforming `Graph` into `Descriptor`s - that is it won't necessarily write to disk on its own by default, but allows clients to examine the generated `XcodeProj` classes for any final tweaks or analysis (e.g. testing).

Additionally the XcodeProj generator won't perform any external system calls (e.g. it won't do `pod update` or `xcodebuild -resolvePackageDependencies`). This ensures it has no side effects and simplify its testing.

// TODO

# Use cases to prototype

Manifests:
- [ ] Manifest > Models
- [ ] TuistConfig 

Transformers: 
- [x] Add custom build phases
- [x] Add custom targets
- [x] Add custom projects
- [x] Derived files - Stable / Known files (e.g. InfoPlist - side effect of generating a files + updating model) 
- [ ] Derived files - Unstable / Unknown files (e.g. Resources - side effect of generating files that isn't known in advance + updating model)
- [ ] Control transformers via tuist config 
   - Each transformer could consult the tuist config at the appropriate path
   - Or selectively register transformers based on one tuist config

Linters:
- [x] Existing `TuistGenerator` linters
- [x] Custom linter
- [ ] Manifest vs model linters

Generator descriptors:
- [ ] workspace descriptors
- [ ] scehemes
