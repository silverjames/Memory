//
//  MemoryCard.swift
//  Memory
//  This structure represents a single memory card
//
//  Created by Bernhard F. Kraft on 22.05.18.
//  Copyright © 2018 Bernhard F. Kraft. All rights reserved.
//

import Foundation

struct MemoryCard: Hashable {

    static var uniqueIdentifier = 0
    static func uniqueIdentifierFactory(){
        uniqueIdentifier += 1
    }
    static func == (lhc:MemoryCard, rhc:MemoryCard) -> Bool{
        return lhc.number == rhc.number
    }
    enum cardStates {
        case faceUp
        case matched
        case faceDown
    }
    private var number:Int = 0

    // **************************************
    // MARK: API
    // **************************************
    var id:Int
    var state:cardStates
    var designation: Int{
        get{
            return number
        }
        set (newValue) {
            number = newValue
        }
    }
    var description: String{
        get {
            return "Card \(id) with number \(self.number)"
        }
    }
    
    init(withDesignation:Int){
        state = .faceDown
        id = MemoryCard.uniqueIdentifier
        MemoryCard.uniqueIdentifierFactory()
        designation = withDesignation
    }

}
