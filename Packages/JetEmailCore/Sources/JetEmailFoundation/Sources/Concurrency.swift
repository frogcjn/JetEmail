//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import class Foundation.Thread

public func checkBackgroundThread(file: String = #file, function: String = #function) {
    if Thread.isMainThread {
        print(file, function, "on main thread")
    }
}

public extension Sequence where Element: Sendable {
    func asyncMap<T>(
        _ transform: @Sendable (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            try await values.append(transform(element))
        }
        
        return values
    }
    
    func forEachTask(operation: @Sendable @escaping (Element) async throws -> Void) async throws { // TODO: Swift 6.0, infer actor
        try await withThrowingDiscardingTaskGroup { group in
            forEach { element in
                group.addTask { try await operation(element) }
            }
        }
    }
    
    func forEachTask(operation: @Sendable @escaping (Element) async -> Void) async { // TODO: Swift 6.0, infer actor
        await withDiscardingTaskGroup { group in
            forEach { element in
                group.addTask { await operation(element) }
            }
        }
    }
    
    /*func forEachTask(isolation actor: isolated any Actor, operation: @Sendable @escaping (Element) async throws -> Void) async throws { // TODO: Swift 6.0, infer actor
        try await withThrowingDiscardingTaskGroup { group in
            forEach { element in
                group.addTask { try await operation(element) }
            }
        }
    }
    
    func forEachTask(isolation actor: isolated any Actor, operation: @Sendable @escaping (Element) async -> Void) async { // TODO: Swift 6.0, infer actor
        await withDiscardingTaskGroup { group in
            forEach { element in
                group.addTask { await operation(element) }
            }
        }
    }*/
}
