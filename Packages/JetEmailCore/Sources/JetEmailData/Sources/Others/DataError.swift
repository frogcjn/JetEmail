//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/24/24.
//

public enum      SessionError : CodableErrorType, Sendable {
    case noSession
}

public enum   ModelStoreError : CodableErrorType, Sendable {
    case notFound
}

public enum PlatformEnumError : CodableErrorType, Sendable {
    case noPlatform(Platform)
}
