//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//


import SwiftUI
import AuthenticationServices

#if os(macOS)
import AppKit
public typealias Application = NSApplication
public typealias Window = NSWindow
public typealias ViewController = NSViewController
#else
import UIKit
public typealias Application = UIApplication
public typealias Window = UIWindow
public typealias ViewController = UIViewController
#endif

#if !os(macOS)
import UIKit
public extension UIApplication {
    @MainActor // for window
    static var sharedFirstNonornamentWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .flatMap {
                ($0 as? UIWindowScene)?.windows.filter { !$0.isOrnamentWindow } ?? [] // do not use keyWindow, since it may refer to an Ornament Window
            }
            .first
    }
}
#else
import AppKit
public extension NSApplication {
    @MainActor
    static var sharedFirstNonornamentWindow: NSWindow? {
        NSApplication
            .shared
            .windows
            .first
    }
}
#endif

@MainActor
public struct SignInPresentationAnchor {
    /*public let webAuthenticationSession: WebAuthenticationSession
    public init(webAuthenticationSession: WebAuthenticationSession) {
        self.webAuthenticationSession = webAuthenticationSession
    }*/
}

public enum SignInPresentationAnchorError : CodableErrorType {
    case authorizeNoMainWindow
    case authorizeNoMainViewController
}

extension Window {
    var isOrnamentWindow: Bool {
        String(describing: self).contains("OrnamentBackingWindow")
    }
}

@MainActor
public extension SignInPresentationAnchor {
    

    static var sharedKeyWindow : Window { get throws {
        guard let window = Application.sharedFirstNonornamentWindow else { throw SignInPresentationAnchorError.authorizeNoMainWindow }
        return window
    } }
    
#if !os(macOS)

    static var sharedKeyViewController : ViewController { get throws {
        guard let viewController = try sharedKeyWindow.rootViewController  else { throw SignInPresentationAnchorError.authorizeNoMainViewController }
        return viewController
    } }
#else
    static var sharedKeyViewController : ViewController { get throws {
        guard let viewController = try sharedKeyWindow.contentViewController  else { throw SignInPresentationAnchorError.authorizeNoMainViewController }
        return viewController
    } }
#endif

}


/*if let window, !window.isOrnamentWindow {
    return window
} else if let window = Application.sharedFirstNonornamentWindow, !window.isOrnamentWindow {
    self.window = window
    return window
}*/

/*static func record(webAuthenticationSession: WebAuthenticationSession) { // resolve issue when presenting window with orminent in visionOS
    window = try? sharedKeyWindow
    self.webAuthenticationSession = webAuthenticationSession
}*/

//static var window : Window?
//static var webAuthenticationSession: WebAuthenticationSession?


/*var presentationWindow: Window { get throws {
    try window ?? Self.sharedKeyWindow
} }*/


/*var presentationViewController: ViewController { get throws {
    try window?.rootViewController ?? Self.sharedKeyViewController
} }*/
