//
//  ContentView.swift
//  DemoApp
//
//  Created by Vyacheslav Razumeenko on 03.02.2025.
//

import SwiftUI
import ToastsUI

private enum TestError: Error {
    case test1
}

struct ContentView: View {
    private typealias ToastValue = ToastManager.ToastValue

    @Environment(\.presentToast) var presentToast

    var body: some View {
        VStack {
            Group {
                Button("Show Toast") {
                    let toast = ToastValue(
                        icon: Image(systemName: "bell"),
                        message: "You have a new notification. You have a new notification.",
                        button: .init(title: "OK", color: .green, action: { })
                    )
                    presentToast(toast)
                }
                Button("Show Red Toast") {
                    let toast = ToastValue(
                        icon: Image(systemName: "bell"),
                        message: "You have a new notification.",
                        button: .init(title: "OK", color: .red, action: { })
                    )
                    presentToast(toast)
                }
                Button("Show text only") {
                    let toast = ToastValue(message: "Text only")
                    presentToast(toast)
                }
                Button("Show Loader") {
                    Task {
                        try await presentToast(message: "Loading") {
                            try await Task.sleep(for: .seconds(3))
                        } onSuccess: { _ in
                                .init(message: "Success")
                        } onFailure: { _ in
                                .init(message: "Error")
                        }
                    }
                }
                Button("Show Loader with error") {
                    Task {
                        try await presentToast(message: "Loading") {
                            try await Task.sleep(for: .seconds(3))
                            throw TestError.test1
                        } onSuccess: { _ in
                                .init(message: "Success")
                        } onFailure: { _ in
                                .init(message: "Error")
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
