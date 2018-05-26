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
    //  MARK: API
    //******************************
    //******************************
    //  MARK: properties
    //******************************

    var gameSet = [MemoryCard]()
    var flipCount = 0
    var faceupCards = Set<Int>()
    var unmatchedFaceUpCards: Int {
        didSet {
            switch unmatchedFaceUpCards {
            case 1:
                faceupCards.removeAll()
//                faceupCards.insert(currentCardIndex)
            case 2:
                checkForMatch()
            default:
                break
            }
        }
    }
    
    //******************************
    //  MARK: class methods
    //******************************
     init(_ withNbrOfCards: Int) {
        self.unmatchedFaceUpCards = 0
        newGame(nbrOfCards: withNbrOfCards)
    }
    
    func cardTouch(cardIndex:Int){
        
    }
    
    func newGame(nbrOfCards: Int){
        gameSet.removeAll()
        for _ in 0...nbrOfCards/2-1 {
            let card = MemoryCard()
            gameSet += [card, card]
        }
        shuffle()
        print("memory set initialized with \(gameSet.count) cards")
    }
    
    //******************************
    //  MARK: private methods
    //******************************
    func checkForMatch() {
        
    }
    
    private func shuffle(){
        var last = gameSet.count - 1
        
        while last > 0 {
            let rand = Int(arc4random_uniform(UInt32(last)))
            gameSet.swapAt(last, rand)
            last -= 1
        }
    }
}
