//
//  ToastLoadingView.swift
//  ToastsUI
//
//  Created by Vyacheslav Razumeenko on 31.01.2025.
//

import SwiftUI

private typealias RootView = ToastRootView
private typealias LoadingView = RootView.LoadingView

// MARK: - LoadingView
extension RootView {
    internal struct LoadingView: View {
        @State private var toggle = false

        var body: some View {
            content()
                .frame(width: 16, height: 16)
                .onAppear {
                    withAnimation(.linear.repeatForever(autoreverses: false).speed(0.3)) {
                        toggle = true
                    }
                }
        }
    }
}

// MARK: - Private Layout
private extension LoadingView {
    @ViewBuilder func content() -> some View {
        ZStack {
            Circle()
                .stroke(Color.primary.opacity(0.2), lineWidth: 2)

            Circle()
                .trim(from: 0.0, to: 0.3)
                .stroke(Color.primary, lineWidth: 2)
                .rotationEffect(.degrees(toggle ? 360 : 0))
        }
    }
}

#Preview {
    LoadingView()
}
