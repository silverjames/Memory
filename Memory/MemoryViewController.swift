//
//  MemoryViewController.swift
//  Memory
//
//  Created by Bernhard F. Kraft on 20.05.18.
//  Copyright © 2018 Bernhard F. Kraft. All rights reserved.
//

import UIKit
import Foundation

class MemoryViewController: UIViewController, cardViewDataSource {

    //******************************
    //  MARK: properties and outlets
    //******************************
    private var game:MemoryGameSet? = nil
    private var imageSet:[UIImage] = []
    private var selectedCards = [Int:Int]() //key: card ID, value: card index in deck
    private var nbrOfCards:Int {
        get{
            return imageSet.count * 2
        }
    }

    @IBOutlet var gameView: UIView!
    
    @IBOutlet weak var cardView: MemoryView!{
        didSet {
            cardView.delegate = self
        }
    }
    @IBOutlet weak var flipCountDisplay: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var gameScore: UILabel!

    // **************************************
    // MARK: protocol functions
    // **************************************
    func getGridDimensions() -> (cellCount: Int, aspectRatio: CGFloat) {
        return (game!.gameSet.count, CGFloat(1.0))
    }
    func getCurrentDeck() -> [MemoryCard] {
        return self.game!.gameSet
    }
    func getImageSet() -> [UIImage] {
        return imageSet
    }

    //******************************
    //  MARK: lifecycle function overrides
    //******************************
    override func viewDidLoad() {
        super.viewDidLoad()

        flipCountDisplay.text = nil
        selectedCards.removeAll()
        let _ = fillImageSet()

        //initialize game with as many cards as we have
        game = MemoryGameSet(nbrOfCards)
        
        //get the images for the game loaded up

        //make them look nice
        for subView in view.subviews{
            if subView is UIButton {
                //button.backgroundColor = UIColor.clearColor()
                subView.layer.cornerRadius = 8
                subView.layer.borderWidth = 0.4
                subView.mask?.clipsToBounds = true
                subView.layer.borderColor = UIColor.gray.cgColor
            } else{
                if subView is UILabel{
                    subView.layer.cornerRadius = 10
                    subView.layer.borderWidth = 0.2
                    subView.mask?.clipsToBounds = true
                    subView.layer.borderColor = UIColor.gray.cgColor
                    subView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateCounters()
    }
    
    //******************************
    //  MARK: button actions
    //******************************
    @objc func touchCard(_ sender: UIButton) {

//      identify the specific card that was touched
        let cardButton = cardView.gameButtons.first(where: {$0.value == sender})
        let card = game?.gameSet.filter {$0.id == cardButton!.key}
        let idx = game?.gameSet.firstIndex(of: card![0])
        game?.flipCount += 1
        
        switch selectedCards.count{
                
            case 0:
                if cardButton != nil{
                    selectedCards[cardButton!.key] = idx!
                    game!.gameSet[idx!].state = .faceUp
                    cardView.formatFaceUpCard(button: sender, atIndex: idx!)
                }
                
            case 1:
                if cardButton != nil{
                    selectedCards[cardButton!.key] = idx
                    game!.gameSet[idx!].state = .faceUp
                    cardView.formatFaceUpCard(button: sender, atIndex: idx!)
                }
                
                let keys = selectedCards.map({$0.key})
                let indices = selectedCards.map {$0.value}
                if game!.match(keys: indices){
                    print("cards matched!")
                    indices.forEach{game!.gameSet[$0].state = .matched}
                    game?.matchCount += 1
                    game?.score += Constants.matchPoints
                    amimateAndHideMatchedPair(keys: keys)
                    selectedCards.removeAll()
                } else {
                    print("cards did not match!")
                    game?.score += Constants.mismatchPoints
                    _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in self.turnBackCards(keys: keys, indices: indices)})
                }
                
            default:
                break

            }//switch
        gameView.setNeedsLayout()
    }//func

    @IBAction func newGame(_ sender: UIButton) {
//        _ = fillImageSet()
        game!.newGame(nbrOfCards: nbrOfCards)
        updateCounters()
        cardView.setNeedsLayout()
//        shuffle()
        }
    
  
    //******************************
    //  MARK: class methods
    //******************************
    
    private func amimateAndHideMatchedPair(keys: [Int]){
        keys.forEach {key in
            UIView.transition(with: self.cardView.gameButtons[key]!,
                              duration: 0.7, options: [.transitionCrossDissolve],
                              animations: {
                                self.cardView.gameButtons[key]!.alpha = 0
                                },
                              completion: { finished in
                                self.cardView.gameButtons[key]!.isHidden = true
                                self.cardView.gameButtons[key]!.alpha = 1
            })
        }
    }// end func
    
    private func turnBackCards(keys: [Int], indices:[Int]) {
        keys.forEach {
            cardView.formatFaceDownCard(button: cardView.gameButtons[$0]!)
        }
        indices.forEach{
            game!.gameSet[$0].state = .faceDown
        }
        selectedCards.removeAll()
    }
    
    private func updateCounters(){
        flipCountDisplay.text = "Flips: \(game!.flipCount)"
        gameScore.text = "Score: \(game!.score)"
        matchLabel.text = "Matches: \(game!.matchCount)"
    }
    
    private func fillImageSet() -> Int {
        //  MARK: creates one entry for each image - would be nicer if I could find a way to iterate through the available images
        imageSet.removeAll()
        imageSet.append(UIImage(named: "Bernhard")!)
        imageSet.append(UIImage(named: "Ildiko")!)
        imageSet.append(UIImage(named: "Kathi")!)
        imageSet.append(UIImage(named: "Marie")!)
        imageSet.append(UIImage(named: "Teresa")!)
        imageSet.append(UIImage(named: "Juliana")!)
        imageSet.append(UIImage(named: "Gerhard")!)
        imageSet.append(UIImage(named: "Bärbel")!)
        imageSet.append(UIImage(named: "Werner")!)
        imageSet.append(UIImage(named: "Thea")!)
        imageSet.append(UIImage(named: "Christina")!)
        imageSet.append(UIImage(named: "Kitty")!)

//        shuffle()
        return imageSet.count
    }

    private func shuffle(){
        var last = imageSet.count - 1
        while last > 0 {
            let rnd = last.arc4Random
            imageSet.swapAt(last, rnd)
            game?.gameSet.swapAt(last, rnd)
            last -= 1
        }
    }

}
extension Int {
    var arc4Random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

struct Constants {
    static let mismatchPoints = -2
    static let matchPoints = 5
    static let deselectPoints = -1
}

