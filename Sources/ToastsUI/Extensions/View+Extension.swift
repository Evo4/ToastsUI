//
//  View+Extension.swift
//  ToastsUI
//
//  Created by Vyacheslav Razumeenko on 31.01.2025.
//

import SwiftUI
import Utility

extension View {
    @ViewBuilder
    internal func _onChange<V: Equatable>( // swiftlint:disable:this identifier_name
        of value: V,
        initial: Bool = false,
        _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void
    ) -> some View {
        if #available(iOS 17.0, *) {
            self.onChange(of: value, initial: initial, action)
        } else {
            self
                .onAppear {
                    if initial { action(value, value) }
                }
                .onChange(of: value) { [oldValue = value] newValue in
                    action(oldValue, newValue)
                }
        }
    }
}
