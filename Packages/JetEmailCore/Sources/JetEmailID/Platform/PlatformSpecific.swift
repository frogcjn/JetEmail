//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

// MARK: - Platform Specific

public protocol PlatformSpecific : ResourceIDProtocol {
    static var platform: Platform { get }
}

public extension PlatformSpecific {
    var platform : Platform { Self.platform }
}


