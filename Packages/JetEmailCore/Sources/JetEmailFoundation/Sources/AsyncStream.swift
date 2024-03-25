//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

public protocol AsyncSequenceOf<Element>: AsyncSequence {}
extension AsyncThrowingStream : AsyncSequenceOf {}
extension AsyncMapSequence : AsyncSequenceOf {}
