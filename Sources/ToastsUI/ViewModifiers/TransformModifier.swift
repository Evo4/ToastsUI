//
//  TransformModifier.swift
//  ToastsUI
//
//  Created by Vyacheslav Razumeenko on 31.01.2025.
//

import SwiftUI

internal struct TransformModifier: ViewModifier {
    var opacity: Double
    var scale: CGFloat
    var yOffset: CGFloat

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .scaleEffect(scale)
            .offset(y: yOffset)
    }
}
