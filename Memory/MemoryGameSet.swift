//
//  MemoryGameSet.swift
//  Memory
//
//  Created by Bernhard F. Kraft on 22.05.18.
//  Copyright © 2018 Bernhard F. Kraft. All rights reserved.
//

import Foundation

class MemoryGameSet {
    //******************************
    //  MARK: API (properties & functions)
    //******************************
    var gameSet = [MemoryCard]()
    var flipCount = 0
    var matchCount = 0
    var score = 0

    init(_ withNbrOfCards: Int) {
        newGame(nbrOfCards: withNbrOfCards)
    }
    
    func newGame(nbrOfCards: Int){
        flipCount = 0
        matchCount = 0
        score = 0
        gameSet.removeAll()
        
        for idx in 0...nbrOfCards/2-1 {
            let card1 = MemoryCard(withDesignation: idx)
            let card2 = MemoryCard(withDesignation: idx)
            gameSet.append(card1)
            gameSet.append(card2)
        }
        gameSet.shuffle()
        print("memory set initialized with \(gameSet.count) cards")
    }

    func match(keys: [Int]) -> Bool{
        var match = false
        if keys.count == 2{
            if gameSet[keys[0]].designation == gameSet[keys[1]].designation {
                match = true
            }
        }
        return match
    }

}

