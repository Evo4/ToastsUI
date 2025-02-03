//
//  ToastManager+ToastValue.swift
//  ToastsUI
//
//  Created by Vyacheslav Razumeenko on 31.01.2025.
//

import Foundation
import SwiftUI

extension ToastManager {
    // MARK: - ToastValue
    public struct ToastValue: Identifiable, Hashable {
        public let id: UUID = .init()

        internal var icon: AnyView?
        internal var message: String
        internal var button: ToastButton?
        /// If nil, the toast will persist and not disappear. Used when displaying a loading toast.
        internal var duration: TimeInterval?

        public init(
            icon: (any View)? = nil,
            message: String,
            button: ToastButton? = nil,
            duration: TimeInterval = 3.0
        ) {
            self.icon = icon.map { AnyView($0) }
            self.message = message
            self.button = button
            self.duration = min(max(0, duration), 10)
        }

        @_disfavoredOverload
        internal init(
            icon: (any View)? = nil,
            message: String,
            button: ToastButton? = nil,
            duration: TimeInterval? = nil
        ) {
            self.icon = icon.map { AnyView($0) }
            self.message = message
            self.button = button
            self.duration = duration
        }

        // MARK: - Equatable
        public static func == (lhs: ToastValue, rhs: ToastValue) -> Bool {
            lhs.message == rhs.message &&
            lhs.button == rhs.button &&
            lhs.duration == rhs.duration &&
            lhs.id == rhs.id
        }

        // MARK: - Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(message)
            hasher.combine(button)
            hasher.combine(duration)
        }
    }

    // MARK: - ToastButton
    public struct ToastButton: Identifiable, Hashable {
        public let id: UUID = .init()
        public var title: String
        public var color: Color
        public var action: () -> Void

        public init(
            title: String,
            color: Color = .primary,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.color = color
            self.action = action
        }

        // MARK: - Equatable
        public static func == (lhs: ToastButton, rhs: ToastButton) -> Bool {
            lhs.title == rhs.title &&
            lhs.color == rhs.color &&
            lhs.id == rhs.id
        }

        // MARK: - Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(title)
            hasher.combine(color)
        }
    }
}
