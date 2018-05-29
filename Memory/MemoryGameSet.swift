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
    var unmatchedCardId: Int?
    var unmatchedCardIndex: Int?
    var pair: (Int , Int)
    
    //******************************
    //  MARK: class methods
    //******************************
     init(_ withNbrOfCards: Int) {
        pair = (999, 999)
        newGame(nbrOfCards: withNbrOfCards)
    }
    
    func cardTouch(cardIndex:Int) -> (statA: Bool, statB:Bool, statC:Bool, pair0: Int, pair1:Int){
        
        var firstTurn = false
        var pairNoMatch = false
        var matchedPair = false
        
        
        if gameSet[cardIndex].faceUp == false{
            gameSet[cardIndex].faceUp = true
            if unmatchedCardId == nil{
                unmatchedCardId = gameSet[cardIndex].id
                unmatchedCardIndex = cardIndex
                pair.0 = cardIndex
                firstTurn = true
            } else {//check for match
                if unmatchedCardId! == gameSet[cardIndex].id {// match!
                    print("Match!")
                    gameSet[cardIndex].matched = true
                    gameSet[unmatchedCardIndex!].matched = true
                    pair.1 = cardIndex
                    matchedPair = true
                } else {
                    pairNoMatch = true
                    pair.1 = cardIndex
                    
                }
                unmatchedCardIndex = nil
                unmatchedCardId = nil
            }
        }
        return (firstTurn, pairNoMatch, matchedPair, pair.0, pair.1)
    }
    
    func newGame(nbrOfCards: Int){
        gameSet.removeAll()
        for _ in 0...nbrOfCards/2-1 {
            let card = MemoryCard()
            gameSet.append(card)
        }
        for index in 0...gameSet.count-1 {
            gameSet.append(gameSet[index])
        }

//        shuffle()
        flipCount = 0
        print("memory set initialized with \(gameSet.count) cards")
        var counter = 0
        for card in gameSet {
            print ("\(counter) - \(card)")
            counter += 1
        }
       
    }
    
    //******************************
    //  MARK: private methods
    //******************************
    
    private func shuffle(){
        var last = gameSet.count - 1
        
        while last > 0 {
            let rand = Int(arc4random_uniform(UInt32(last)))
            gameSet.swapAt(last, rand)
            last -= 1
        }
    }
}
