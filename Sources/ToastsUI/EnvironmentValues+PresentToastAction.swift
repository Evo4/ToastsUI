import SwiftUI

extension EnvironmentValues {
    public internal(set) var presentToast: PresentToastAction {
        get { self[PresentToastKey.self] }
        set { self[PresentToastKey.self] = newValue }
    }
}

public struct PresentToastAction {
    // swiftlint:disable:next identifier_name
    internal weak var _manager: ToastManager?
    private var manager: ToastManager {
        // swiftlint:disable:next identifier_name
        guard let _manager else {
            fatalError("View.installToast must be called on a parent view to use EnvironmentValues.presentToast.")
        }
        return _manager
    }

    @MainActor
    public func callAsFunction(_ toast: ToastManager.ToastValue) {
        manager.append(toast)
    }

    public func callAsFunction<V>(
        message: String,
        task: () async throws -> V,
        onSuccess: (V) -> ToastManager.ToastValue,
        onFailure: (any Error) -> ToastManager.ToastValue
    ) async throws -> V {
        try await manager.append(
            message: message,
            task: task,
            onSuccess: onSuccess,
            onFailure: onFailure
        )
    }
}

private enum PresentToastKey: EnvironmentKey {
    static let defaultValue: PresentToastAction = .init()
}
