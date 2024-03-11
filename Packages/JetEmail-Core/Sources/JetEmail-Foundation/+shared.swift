//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 2/25/24.
//

import Foundation

/*
@globalActor
public actor BackgroundActor {
    public static let shared = BackgroundActor()
}*/

#if !os(macOS)
import UIKit
public extension UIApplication {
    @MainActor // for window
    static var sharedKeyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
    }
}
#else
import AppKit
public extension NSApplication {
    @MainActor
    static var sharedKeyWindow: NSWindow? {
        NSApplication
            .shared
            .windows
            .first
    }
}
#endif


