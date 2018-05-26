//
//  MemoryCard.swift
//  Memory
//  This structure represents a single memory card
//
//  Created by Bernhard F. Kraft on 22.05.18.
//  Copyright © 2018 Bernhard F. Kraft. All rights reserved.
//

import Foundation

struct MemoryCard {
    var id: Int
    var faceUp: Bool = false
    var matched: Bool = false

    static var uniqueIdentifier = 0
    static func uniqueIdentifierFactory(){
        uniqueIdentifier += 1
    }
    init(){
        id = MemoryCard.uniqueIdentifier
        faceUp = false
        matched = false
        MemoryCard.uniqueIdentifierFactory()
    }
}
