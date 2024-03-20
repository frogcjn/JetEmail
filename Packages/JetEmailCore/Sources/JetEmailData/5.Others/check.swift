//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import Foundation

public func checkBackgroundThread(function: String = #function) {
    if Thread.isMainThread {
        print(function, "on main thread")
    }
}
