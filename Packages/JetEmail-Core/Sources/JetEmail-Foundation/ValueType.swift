//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

public protocol ValueType : Equatable, Hashable, Sendable {}
public protocol CodableValueType : ValueType, Codable {}
public protocol CodableErrorType : Error, CodableValueType {}
public protocol IdentifiableValueType : CodableValueType, Identifiable {}
