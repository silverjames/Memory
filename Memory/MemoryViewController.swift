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
    //  MARK: properties and outlets
    //******************************

//    private var blankImage:UIImage? = nil
    private var game:MemoryGameSet? = nil
    private var imageSet:[UIImage] = []
    private var selectedCards = [Int:UIButton]()
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

    //******************************
    //  MARK: lifecycle function overrides
    //******************************
    override func viewDidLoad() {
        super.viewDidLoad()

        flipCountDisplay.text = nil
        let _ = fillImageSet()

        //initialize game with as many cards as we have
        game = MemoryGameSet(nbrOfCards)
        
        //get the images for the game loaded up

        //make them look nice
        for subView in view.subviews{
            if subView is UIButton {
                //button.backgroundColor = UIColor.clearColor()
                subView.layer.cornerRadius = 10
                subView.layer.borderWidth = 0.2
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
    
    //******************************
    //  MARK: button actions
    //******************************
    @objc func touchCard(_ sender: UIButton) {

        print ("card touched")

        if selectedCards.contains(where: {$0.value == sender }){
            selectedCards.remove(at: selectedCards.firstIndex(where: {$0.value == sender })!)
            cardView.buttonFormatNotSelected(button: sender)
            game!.score += Constants.deselectPoints
//            updateScore()
            
        } else {
            switch selectedCards.count{
                
            case 0:
                let card = cardView.gameButtons.first(where: {$0.value == sender})!
                selectedCards[card.key] = sender
                game!.gameSet[card.key].state = .faceUp
                cardView.buttonFormatSelected(button: sender, atIndex: card.key)
                
            case 1:
                let card = cardView.gameButtons.first(where: {$0.value == sender})!
                selectedCards[card.key] = sender
                game!.gameSet[card.key].state = .faceUp
                cardView.buttonFormatSelected(button: sender, atIndex: card.key)
                
                let keys = selectedCards.map({$0.key})
                if game!.match(keys: keys){
                    print("cards matched!")
                    for id in keys{
                        game!.gameSet[id].state = .matched
                    }
                    amimateAndHideMatchedPairs()
//                    _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in self.processMatch(matchSet: keys)})
                } else {
                    print("cards did not match!")
//                    _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in self.processMismatch(matchSet: keys)})
                }
                
            default:
                let keys = selectedCards.map({$0.key})
                for id in keys{
                    game!.gameSet[id].state = .faceDown
                }//for
                selectedCards.removeAll()

            }//switch
        }//else
    }//func

    @IBAction func newGame(_ sender: UIButton) {
        _ = fillImageSet()
        game!.newGame(nbrOfCards: nbrOfCards)
        shuffle()
        }
    
  
    //******************************
    //  MARK: class methods
    //******************************
    
    private func amimateAndHideMatchedPairs(){
//        print("about to hide the matched pairs")
        for cardIndex in game!.gameSet.indices {
            if game!.gameSet[cardIndex].state == .matched{
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0.0, options: [.curveEaseInOut],
                      animations: {
                        self.cardView.gameButtons[cardIndex]!.transform = CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0)
                        },
                        completion: { _ in
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 1.0, options: [],
                                    animations: {
                                        self.cardView.gameButtons[cardIndex]?.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                            })
                })//first animation

//                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 5.0, options: [.curveEaseInOut],
//                        animations: {
//                            self.memoryButtons[cardIndex].alpha = 0
//                        },
//                        completion: { finished in
//                            self.memoryButtons[cardIndex].isHidden  = true
//                            self.memoryButtons[cardIndex].alpha = 1
//                            self.memoryButtons[cardIndex].transform = .identity
//                            }
//                )//second animation

                
                
                
                //                                    completion: { position in
//                                        self.memoryButtons[cardIndex].setImage(self.blankImage, for: UIControl.State.normal)
//                                        self.memoryButtons[cardIndex].alpha = 0
//                                    })//end completion
//
//                            })//end completion
            }// if match
        }//for-loop
        
    }// end func
    
    private func fillImageSet() -> Int {
        //  creates one entry for each image - would be nicer if I could find a way to iterate through the available images
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
    static let mismatchPoints = -4
    static let cheatPoints = -5
    static let deselectPoints = -1
}

