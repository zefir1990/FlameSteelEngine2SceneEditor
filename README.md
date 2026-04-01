# Flame Steel Engine 2 Scene Editor

Scene editor for Flame Steel Engine 2, written in Swift.  
The top-level API is **declarative** and **reactive** — UI is described as a composition of views with reactive bindings that keep the interface in sync with the data model.

## Packages

### PresentationKit
Declarative UI framework. Provides the core `View` protocol, `@ViewBuilder` result builder, and a set of built-in views:

### ReactiveTech
Lightweight reactive data binding. Provides:

### SceneControls
Scene-specific UI controls. Provides:

- `SceneView` — viewport for rendering and editing the scene, bound to an objects list via `Binding`.

## Build & Run

```bash
swift build
swift run
```

## License

MIT
