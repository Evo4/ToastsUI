//
//  Color+DarkMode.swift
//  ToastsUI
//
//  Created by Vyacheslav Razumeenko on 31.01.2025.
//

import struct SwiftUI.Color
import class UIKit.UIColor

extension UIColor {
    internal convenience init(light: UIColor, dark: UIColor) {
        self.init { $0.userInterfaceStyle == .dark ? dark : light }
    }
}

extension Color {
    internal init(light: Color, dark: Color) {
        self.init(uiColor: .init(light: UIColor(light), dark: UIColor(dark)))
    }
}

extension Color {
    internal static let toastBackground: Color = Color(light: .white, dark: Color(white: 0.12))
}
