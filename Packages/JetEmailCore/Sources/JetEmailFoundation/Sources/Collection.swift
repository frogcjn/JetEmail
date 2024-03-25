//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/25/24.
//

// MARK: Collection

public extension Collection {
    var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}
