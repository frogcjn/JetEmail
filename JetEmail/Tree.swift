//
//  Tree.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

class Tree<Value> {
    var root: TreeNode<Value>
    
    init(rootValue: Value) {
        self.root = TreeNode(value: rootValue)
    }
    
    init(root: TreeNode<Value>) {
        self.root = root
    }
}

extension TreeNode {
    func descendants() -> [TreeNode<Value>] {
        var queue: [TreeNode<Value>] = [self]
        var result: [TreeNode<Value>] = []
        while !queue.isEmpty {
            print(queue)
            let current = queue.removeFirst()
            result.append(current)
            queue.append(contentsOf: current.children)
        }
        return result
    }
}
    

@dynamicMemberLookup
class TreeNode<Value> {
    weak var parent: TreeNode<Value>? = nil
    var children: [TreeNode<Value>] = []
    var value: Value
    
    init(parent: TreeNode<Value>? = nil, children: [TreeNode<Value>] = [], value: Value) {
        self.parent = parent
        self.children = children
        self.value = value
    }
}

// @dynamicMemberLookup
extension TreeNode {
    
    subscript<TargetValue>(dynamicMember keyPath: KeyPath<Value, TargetValue>) -> TargetValue {
        value[keyPath: keyPath]
    }
    
    subscript<TargetValue>(dynamicMember keyPath: WritableKeyPath<Value, TargetValue>) -> TargetValue {
        get {
            value[keyPath: keyPath]
        }
        set {
            value[keyPath: keyPath] = newValue
        }
    }
}
