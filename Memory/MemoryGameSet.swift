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
    var onlyOneCardIsFaceUp:Int?
    var indexForTheOneAndOnlyFaceupCard:Int?
    var nbrOfFaceupCards: Int{
        get {
            let faceUpSet = gameSet.filter {$0.faceUp == true}
            return faceUpSet.count
        }
    }
    
    //******************************
    //  MARK: class methods
    //******************************
     init(_ withNbrOfCards: Int) {
        newGame(nbrOfCards: withNbrOfCards)
    }
    
    func cardTouch(cardIndex:Int){
        
        if gameSet[cardIndex].faceUp == false && !gameSet[cardIndex].matched{
            gameSet[cardIndex].faceUp = true
            if nbrOfFaceupCards > 2{        //if a third card was touched, turn the others around
                for index in gameSet.indices{
                    if index != cardIndex{
                        gameSet[index].faceUp = false
                    }
                }
            }

            if onlyOneCardIsFaceUp == nil{
                onlyOneCardIsFaceUp = gameSet[cardIndex].id
                indexForTheOneAndOnlyFaceupCard = cardIndex
            } else {//check for match
                if onlyOneCardIsFaceUp! == gameSet[cardIndex].id {// match!
                    print("Match!")
                    gameSet[cardIndex].matched = true
                    gameSet[indexForTheOneAndOnlyFaceupCard!].matched = true
                } else {

                }
                onlyOneCardIsFaceUp = nil
            }
        }
    }
    
    func newGame(nbrOfCards: Int){
        onlyOneCardIsFaceUp = nil
        flipCount = 0
        gameSet.removeAll()

        for _ in 0...nbrOfCards/2-1 {
            let card = MemoryCard()
            gameSet.append(card)
        }
        for index in 0...gameSet.count-1 {
            gameSet.append(gameSet[index])
        }
        print("memory set initialized with \(gameSet.count) cards")
        var counter = 0
        for card in gameSet {
            print ("\(counter) - \(card)")
            counter += 1
        }
    }
}