//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

public typealias             ValueType = Hashable & Sendable //{}
public typealias      CodableValueType = ValueType & Codable //{}
public typealias      CodableErrorType = CodableValueType & Error //{}
public typealias IdentifiableValueType = CodableValueType & Identifiable //{}
