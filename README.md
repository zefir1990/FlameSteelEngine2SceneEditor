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

## PresentationKit Frontend

The UI rendering engine is controlled by the `PresentationKitFrontend` environment variable. This allows the application to be built with different UI backends:

| Environment Variable | Package | Description |
| :--- | :--- | :--- |
| `PresentationKitFrontend=wx` (Default) | `WxClientPresentationKit` | Uses a remote web-based client for rendering. |
| `PresentationKitFrontend=UIKit` | `UIKitPresentationKit` | Native UIKit implementation for iOS and Mac Catalyst. |
| `PresentationKitFrontend=SwiftUI` | `SwiftUIPresentationKit` | Native SwiftUI implementation. |

To specify the frontend when building or running, set the environment variable:

```bash
PresentationKitFrontend=UIKit swift run
```

## Mac Catalyst Build

A dedicated script `catalyst-build.sh` is provided for building and packaging the application for Mac Catalyst.

The script performs the following actions:
1. Sets `PresentationKitFrontend=UIKit`.
2. Compiles for `arm64-apple-ios-macabi` using the `catalyst.json` destination.
3. Automatically packages the binary into a `.app` bundle in `.build/deploy/`.
4. Copies `Info.plist` and performs ad-hoc codesigning.

### Usage

```bash
./catalyst-build.sh
```

Once compiled, the application can be launched from the deploy directory:

```bash
open .build/deploy/FlameSteelEngine2SceneEditor.app
```

## Build & Run (Standard)

## License

MIT
