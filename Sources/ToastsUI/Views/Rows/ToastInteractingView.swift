//
//  ToastInteractingView.swift
//  ToastsUI
//
//  Created by Vyacheslav Razumeenko on 31.01.2025.
//

import SwiftUI
import Utility

private typealias RootView = ToastRootView
private typealias ToastInteractingView = RootView.ToastInteractingView

// MARK: - ToastInteractingView
extension RootView {
    internal struct ToastInteractingView: View {
        // MARK: - Dependencies
        let model: ToastManager.ToastValue
        @ObservedObject var manager: ToastManager

        // MARK: - Private Properties
        @GestureState private var yOffset: CGFloat?
        @State private var dismissTask: Task<Void, any Error>?
        @MainActor
        private var dragGesture: some Gesture {
            DragGesture(minimumDistance: 0)
                .updating($yOffset) { value, state, _ in
                    let translation = value.translation.height
                    if model.duration == nil {
                        state = translation * 0.5
                    } else {
                        let isTopPosition = manager.position == .top
                        let shouldReduceTranslation = (isTopPosition && translation > 0) || (!isTopPosition && translation < 0)
                        state = shouldReduceTranslation ? translation * 0.5 : translation
                    }
                }
                .onEnded { value in
                    if model.duration == nil { return }
                    let threshold: CGFloat = 48 / 2
                    let draggedAmount = manager.position == .top ? -value.translation.height : value.translation.height
                    if draggedAmount > threshold {
                        manager.remove(model)
                    } else {
                        startDismissTask()
                    }
                }
        }
        private var isDragging: Bool { yOffset != nil }

        // MARK: - Layout
        var body: some View {
            content()
                ._onChange(of: isDragging) { _, newValue in
                    if newValue {
                        dismissTask?.cancel()
                        dismissTask = nil
                    }
                }
                ._onChange(of: model.duration == nil, initial: true) { _, newValue in
                    startDismissTask()

                    log.debug("model: \(model)")
                }
        }
    }
}

// MARK: - Private Layout
private extension ToastInteractingView {
    @ViewBuilder func content() -> some View {
        ToastRootView.ToastView(model: model)
            .offset(y: yOffset ?? 0)
            .simultaneousGesture(dragGesture)
            .animation(.spring, value: isDragging)
            .animation(.easeInOut(duration: 0.1), value: yOffset)
    }
}

// MARK: - Private Methods
private extension ToastInteractingView {
    func startDismissTask() {
        dismissTask?.cancel()
        dismissTask = Task {
            await manager.startRemovalTask(for: model)
        }
    }
}
