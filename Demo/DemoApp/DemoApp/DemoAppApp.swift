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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .installToast(position: .top)
        }
    }
}
