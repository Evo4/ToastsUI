//
//  ToastView.swift
//  ToastsUI
//
//  Created by Vyacheslav Razumeenko on 31.01.2025.
//

import SwiftUI

private typealias RootView = ToastRootView
private typealias ToastView = RootView.ToastView

// MARK: - ToastView
extension RootView {
    internal struct ToastView: View {
        // MARK: - Dependencies
        let model: ToastManager.ToastValue
        @Environment(\.colorScheme) private var colorScheme

        // MARK: - Private Properties
        private var isDark: Bool { colorScheme == .dark }

        // MARK: - Layout
        var body: some View {
            content()
                .frame(height: 48)
                .compositingGroup()
                .shadow(
                    color: .primary.opacity(isDark ? 0.0 : 0.1),
                    radius: 16,
                    y: 8.0
                )
        }
    }
}

// MARK: - Private Layout
private extension ToastView {
    @ViewBuilder func content() -> some View {
        ZStack {
            Capsule()
                .fill(Color.clear)
            toastContentView()
                .transition(
                    .modifier(
                        active: TransformModifier(
                            opacity: -1.0,
                            scale: 1.0,
                            yOffset: 0.0
                        ),
                        identity: TransformModifier(
                            opacity: 1.0,
                            scale: 1.0,
                            yOffset: 0.0
                        )
                    )
                )
                .id(model.message)
                .background {
                    Capsule()
                        .fill(Color.toastBackground)
                }
        }
    }

    @ViewBuilder func toastContentView() -> some View {
        HStack(spacing: 10) {
            iconView()
            Text(model.message)
            buttonView()
        }
        .font(.system(size: 16, weight: .medium))
    }

    @ViewBuilder func iconView() -> some View {
        if let icon = model.icon {
            icon
                .frame(width: 19, height: 19)
                .padding(.leading, 15)
        } else {
            Color.clear
                .frame(width: 14)
        }
    }

    @ViewBuilder func buttonView() -> some View {
        if let button = model.button {
            buttonView(button)
                .padding([.top, .bottom, .trailing], 10)
        } else {
            Color.clear
                .frame(width: 14)
        }
    }

    @ViewBuilder func buttonView(_ button: ToastManager.ToastButton) -> some View {
        Button {
            button.action()
        } label: {
            ZStack {
                Capsule()
                    .fill(button.color.opacity(isDark ? 0.15 : 0.07))
                Text(button.title)
                    .foregroundStyle(button.color)
                    .padding(.horizontal, 9)
            }
            .frame(minWidth: 64)
            .fixedSize(horizontal: true, vertical: false)
        }
        .buttonStyle(.plain)
    }
}

@available(iOS 17.0, *)
#Preview {
    let group = VStack {
        ToastView(
            model: .init(
                icon: Image(systemName: "info.circle"),
                message: "This is a toast message",
                button: .init(title: "Action", color: .red, action: {})
            )
        )
        ToastView(
            model: .init(
                icon: Image(systemName: "info.circle"),
                message: "This is a toast message",
                button: .init(title: "Action", action: {})
            )
        )
        ToastView(
            model: .init(
                icon: Image(systemName: "info.circle"),
                message: "This is a toast message",
                button: nil
            )
        )
        ToastView(
            model: .init(
                icon: nil,
                message: "This is a toast message",
                button: nil
            )
        )
        ToastView(
            model: .init(
                icon: nil,
                message: "Copied",
                button: nil
            )
        )
    }
    return VStack {
        group
        group
            .padding(20)
            .background {
                Color.black
            }
            .environment(\.colorScheme, .dark)
    }
}
