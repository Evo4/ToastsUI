//
//  DemoAppApp.swift
//  DemoApp
//
//  Created by Vyacheslav Razumeenko on 03.02.2025.
//

import SwiftUI
import ToastsUI

@main
struct DemoAppApp: App {
    static let toastManager: ToastManager = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .installToast(position: .top, manager: Self.toastManager)
        }
    }
}
