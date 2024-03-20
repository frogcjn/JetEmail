//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import Foundation

public extension AsyncThrowingStream {
    
    func map<T>(_ transform: @Sendable @escaping (Element) throws -> T) rethrows -> AsyncThrowingStream<T, Error> where Element : Sendable {
        return  AsyncThrowingStream<T, Error> { continuation in Task {
            do {
                for try await element in self {
                    try continuation.yield(transform(element))
                }
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        } }
    }
}
