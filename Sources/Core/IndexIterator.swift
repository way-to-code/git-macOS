//
//  IndexIterator.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

/// Basic iterator class intended to be used for sequences
public struct IndexIterator<T>: IteratorProtocol {
    
    private var index = 0
    private var collection: IndexSequence
    
    init(collection: IndexSequence) {
        self.collection = collection
    }
    
    public mutating func next() -> T? {
        let child = collection[index]
        index += 1
        return child as? T
    }
}

// MARK: - IndexSequence
protocol IndexSequence {
    
    subscript(index: Int) -> Any? { get }
}
