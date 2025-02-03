import SwiftUI
import WindowOverlay

extension View {
    public func installToast(position: ToastManager.ToastPosition = .bottom, manager: ToastManager = .init()) -> some View {
        self.modifier(InstallToastModifier(position: position, manager: manager))
    }
}

private struct InstallToastModifier: ViewModifier {
    var position: ToastManager.ToastPosition
    @State private var manager: ToastManager

    init(position: ToastManager.ToastPosition, manager: ToastManager) {
        self.position = position
        self.manager = manager
    }

    func body(content: Content) -> some View {
        content
            .environment(
                \.presentToast,
                 PresentToastAction(_manager: manager)
            )
            .background {
                InstallToastView(manager: manager)
            }
            ._onChange(of: position, initial: true) {
                manager.position = $1
            }
    }
}

private struct InstallToastView: View {
    @ObservedObject var manager: ToastManager
    var body: some View {
        if manager.isPresented {
            Color.clear
                .windowOverlay(isPresented: true) {
                    ToastRootView(manager: manager)
                }
        }
    }
}
