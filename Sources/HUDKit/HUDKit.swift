// Copyright (c) 2021 Ben Robinson.
// All Rights Reserved.

import SwiftUI
import SFSafeSymbols

public struct HUD<Content: View>: View {
    let content: () -> Content
    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
    
    @available(macOS 11.0, *)
    public init(_ title: String, symbol: SFSymbol? = nil) where Content == DefaultHUDContent {
        self.init(content: { DefaultHUDContent(title, symbol: symbol) })
    }
    
    public var body: some View {
        content()
            .padding(.horizontal, 12)
            .padding(16)
            .background(
                Capsule()
                    .foregroundColor(Color.white)
                    .shadow(color: Color.black.opacity(0.16), radius: 12, x: 0, y: 5)
            )
            .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            .zIndex(1)
    }
}

@available(macOS 11.0, *)
public struct DefaultHUDContent: View {
    let title: String
    let symbol: SFSymbol?
    
    public init(_ title: String, symbol: SFSymbol? = nil) {
        self.title = title
        self.symbol = symbol
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 5.0) {
            if let symbol = symbol {
                Image(systemSymbol: symbol)
            }
            Text(title)
        }
    }
}

public struct HUDContainer<Content: View>: View {
    @ObservedObject private var manager = HUDManager.shared
    @State private var id: UUID?
    let content: () -> Content
    
    public var body: some View {
        ZStack(alignment: .top) {
            content()
            if manager.shouldDisplay,
               let title = manager.title {
                HUD(title, symbol: manager.symbol)
                    .onAppear {
                        id = manager.id
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            if id == manager.id {
                                withAnimation {
                                    manager.dismiss()
                                }
                            }
                        }
                    }
            }
        }
    }
}

public class HUDManager: ObservableObject {
    public static let shared = HUDManager()
    
    @Published internal var shouldDisplay = false
    @Published internal var id = UUID()
    @Published internal var title = ""
    @Published internal var symbol: SFSymbol? = nil
    
    public func display(_ title: String, symbol: SFSymbol? = nil) {
        if shouldDisplay {
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    self.title = title
                    self.symbol = symbol
                    self.id = UUID()
                    self.shouldDisplay = true
                }
            }
        } else {
            withAnimation {
                self.title = title
                self.symbol = symbol
                self.id = UUID()
                self.shouldDisplay = true
            }
        }
    }
    
    public func dismiss() {
        withAnimation {
            shouldDisplay = false
        }
    }
    
    public func forceDismiss() {
        shouldDisplay = false
    }
}
