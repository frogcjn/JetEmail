//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import Foundation

public func checkBackgroundThread(file: String = #file, function: String = #function) {
    if Thread.isMainThread {
        print(file, function, "on main thread")
    }
}
