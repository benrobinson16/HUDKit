# HUDKit

A simple Swift package for managing Apple-like HUD views.

## Basic Usage

To use the default behaviour, first wrap your entire view hierachy in an `HUDContainer` like so (preferably in the `App.swift` file):

```swift
import HUDKit

struct MyApp: Swift {
    var body: some View {
        WindowGroup {
            HUDContainer {
                ContentView()
            }
        }
    }
}
```

This will give the `HUDKit` API the ability to present an HUD above your view hierachy.

Next, when you want to display a HUD:

```swift
import HUDKit

HUDManager.shared.display("Hello, world!")

// or, specifying a symbol

HUDManager.shared.display("Hello, world!", .starFill)
```

The HUD will dismiss automatically after three seconds. To dismiss at any other time, call the following:

```swift
HUDManager.shared.dismiss()         // with animation
HUDManager.shared.forceDismiss()    // without animation
```

## Advanced Usage

If you wish to define your own HUD view content, you must make your own container and display manager. Please see the `Sources` directory for ideas on how to approach this.

Simply, you can use the HUD in a `ZStack` with your custom content:

```swift
import HUDKit

struct ContentView: View {
    @State private var showHUD = false

    var body: some View {
        ZStack {
            // your main view hierachy
            if showHUD {
                HUD {
                    // your custom content
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation {
                            manager.dismiss()
                        }
                    }
                }
            }
        }
    }
}
```

## Installation

For iOS and macOS projects, please install via Xcode's GUI for Swift Packages providing this url: https://github.com/benrobinson16/HUDKit.git

For SwiftPackages, add the following to your dependencies array:

```swift
.package(name: "HUDKit", url: "https://github.com/benrobinson16/HUDKit.git", .upToNextMajor(from: .init(1, 0, 0)))
```

## Credits

Inspired by the HUD interface in [this article](https://fivestars.blog/swiftui/swiftui-hud.html).

[SFSafeSymbols](https://github.com/piknotech/SFSafeSymbols) is used to provide type-safe access to SFSymbols.

## License

Please see LICENSE.md.
