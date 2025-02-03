import SwiftUI
import Utility

// MARK: - ToastManager
@MainActor
public final class ToastManager: ObservableObject {
    // MARK: - ToastPosition
    public enum ToastPosition {
        case top
        case bottom
    }

    // MARK: - Properties
    @Published internal var position: ToastPosition = .top
    @Published internal private(set) var models: IdentifiedArrayOf<ToastValue> = .init()
    @Published internal private(set) var isAppeared = false

    internal var isPresented: Bool {
        !models.isEmpty || isAppeared
    }

    // MARK: - Private Properties
    private var dismissOverlayTask: Task<Void, any Error>?

    // MARK: - Init
    public nonisolated init() {}

    // MARK: - Methods
    internal func onAppear() {
        isAppeared = true
    }

//    @discardableResult
//    internal func showInfo(message: String) -> ToastValue {
//        append(.init(icon: AppAssets.Toast.infoCircle, message: message))
//    }
//
//    @discardableResult
//    internal func showError(message: String) -> ToastValue {
//        append(.init(icon: AppAssets.Toast.exclamationMarkTriangle, message: message))
//    }

    @discardableResult
    internal func append(_ toast: ToastValue) -> ToastValue {
        dismissOverlayTask?.cancel()
        dismissOverlayTask = nil
        models.append(toast)
        return toast
    }

    internal func remove(_ model: ToastValue) {
        log.debug("model: \(model)")
        self.models.remove(id: model.id)
        if models.isEmpty {
            dismissOverlayTask = Task {
                try await Task.sleep(seconds: removalAnimationDuration)
                isAppeared = false
            }
        }
    }

    internal func startRemovalTask(for model: ToastValue) async {
        if let duration = model.duration {
            do {
                try await Task.sleep(seconds: duration)
                remove(model)
            } catch {}
        }
    }

    @discardableResult
    internal func append<V>(
        message: String,
        task: () async throws -> V,
        onSuccess: (V) -> ToastValue,
        onFailure: (any Error) -> ToastValue
    ) async throws -> V {
        let model = append(ToastValue(icon: ToastRootView.LoadingView(), message: message, duration: nil))
        do {
            let value = try await task()
            withAnimation(.spring) {
                let updated = onSuccess(value)
                replaceModels(oldModel: model, with: updated)
            }
            return value
        } catch {
            withAnimation(.spring) {
                let updated = onFailure(error)
                replaceModels(oldModel: model, with: updated)
            }
            throw error
        }
    }

    private func replaceModels(oldModel: ToastValue, with updatedModel: ToastValue) {
        guard let index = self.models.index(id: oldModel.id) else { return }

        self.models[index] = updatedModel
    }
}

internal let removalAnimationDuration: Double = 0.3
