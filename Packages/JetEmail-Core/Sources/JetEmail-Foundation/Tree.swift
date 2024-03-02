//
//  Tree.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

public class Tree<Value> {
    public var root: TreeNode<Value>
    
    public init(rootElement: Value) {
        self.root = TreeNode(element: rootElement)
    }
    
    public init(root: TreeNode<Value>) {
        self.root = root
    }
}

public extension TreeNode {
    func descendants(includesSelf: Bool = true) -> [TreeNode<Element>] {
        var queue: [TreeNode<Element>] = [self]
        var result: [TreeNode<Element>] = []
        while !queue.isEmpty {
            let current = queue.removeFirst()
            result.append(current)
            queue.append(contentsOf: current.children)
        }
        if includesSelf {
            return result
        } else {
            return Array(result.dropFirst())
        }
    }
}
    

@dynamicMemberLookup
public class TreeNode<Element> {
    public weak var parent: TreeNode<Element>? = nil
    public var children: [TreeNode<Element>] = []
    public var element: Element
    
    public init(parent: TreeNode<Element>? = nil, children: [TreeNode<Element>] = [], element: Element) {
        self.parent = parent
        self.children = children
        self.element = element
    }
}

// @dynamicMemberLookup
public extension TreeNode {
    
    subscript<TargetValue>(dynamicMember keyPath: KeyPath<Element, TargetValue>) -> TargetValue {
        element[keyPath: keyPath]
    }
    
    subscript<TargetValue>(dynamicMember keyPath: WritableKeyPath<Element, TargetValue>) -> TargetValue {
        get {
            element[keyPath: keyPath]
        }
        set {
            element[keyPath: keyPath] = newValue
        }
    }
}
