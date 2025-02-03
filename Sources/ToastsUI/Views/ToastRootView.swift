import SwiftUI

// MARK: - ToastRootView
internal struct ToastRootView: View {
    // MARK: - Tuple
    private struct Tuple: Equatable {
        var count: Int
        var isAppeared: Bool
    }

    // MARK: - Dependencies
    @ObservedObject var manager: ToastManager

    // MARK: - Private Properties
    private var models: IdentifiedArrayOf<ToastManager.ToastValue> {
        let models = isTop ? IdentifiedArrayOf(uniqueElements: manager.models.reversed()) : manager.models
        return manager.isAppeared ? models : []
    }
    private var isTop: Bool { manager.position == .top }

    // MARK: - Layout
    var body: some View {
        content()
            .onAppear(perform: manager.onAppear)
    }
}

// MARK: - Private Layout
private extension ToastRootView {
    @ViewBuilder func content() -> some View {
        VStack {
            if !isTop { Spacer() }
            ZStack {
                ForEach(Array(models.reversed().enumerated()), id: \.element) { index, model in
                    toastView(manager: manager, index: index, model: model)
                }
            }
            if isTop { Spacer() }
        }
        .animation(
            .spring(duration: ToastManager.Settings.removalAnimationDuration),
            value: Tuple(count: manager.models.count, isAppeared: manager.isAppeared)
        )
    }

    @ViewBuilder func toastView(
        manager: ToastManager,
        index: Int,
        model: ToastManager.ToastValue
    ) -> some View {
        ToastInteractingView(model: model, manager: manager)
            .transition(
                .modifier(
                    active: TransformModifier(
                        opacity: 0.0,
                        scale: 0.5,
                        yOffset: isTop ? -96 : 96
                    ),
                    identity: TransformModifier(
                        opacity: 1.0,
                        scale: 1.0,
                        yOffset: 0
                    )
                )
            )
            .padding(
                [isTop ? .top : .bottom],
                // Place front element with bottom offset -32.
                // Other elements stay on the same place
                index != (models.indices.last ?? .zero) ? -(CGFloat(index) + 32) : .zero
            )
            .scaleEffect(
                index != (models.indices.last ?? .zero)
                ? CGSize(width: 0.8, height: 0.8)
                : CGSize(width: 1, height: 1)
            )
    }
}
