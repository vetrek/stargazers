//
//  Collection+.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation

extension Collection {
    /**
     Safely access the `Collection` element at any index
     
     - returns: The element at the specified index if exist, nil if not
     */
    subscript(safe index: Index?) -> Element? {
        guard let index = index else { return nil }
        return indices.contains(index) ? self[index] : nil
    }
}
