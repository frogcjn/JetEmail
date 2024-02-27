//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 2/25/24.
//

import Foundation


@globalActor
public actor BackgroundActor {
    public static let shared = BackgroundActor()
}
#if !os(macOS)
import UIKit
public extension UIApplication {
    @MainActor
    static var sharedKeyWinwdow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
    }
}
#endif
