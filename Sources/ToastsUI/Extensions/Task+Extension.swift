//
//  Task+Extension.swift
//  ToastsUI
//
//  Created by Vyacheslav Razumeenko on 31.01.2025.
//

import Foundation

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        if #available(iOS 16.0, *) {
            try await sleep(for: .seconds(seconds))
        } else {
            try await sleep(nanoseconds: UInt64(seconds * 1000) * NSEC_PER_MSEC)
        }
    }
}
