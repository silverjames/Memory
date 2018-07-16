//
//  MemoryViewController.swift
//  Memory
//
//  Created by Bernhard F. Kraft on 20.05.18.
//  Copyright © 2018 Bernhard F. Kraft. All rights reserved.
//

import UIKit
import Foundation

class MemoryViewController: UIViewController {
    //******************************
    //  MARK: properties and outlets
    //******************************

    private var blankImage:UIImage? = nil
    lazy var game = MemoryGameSet(1)
    private var imageSet:[UIImage] = []

    @IBOutlet var gameView: UIView!
    @IBOutlet var memoryButtons: [UIButton]!
    @IBOutlet weak var flipCountDisplay: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var gameScore: UILabel!

    //******************************
    //  MARK: lifecycle function overrides
    //******************************
    override func viewDidLoad() {
        super.viewDidLoad()

        flipCountDisplay.text = nil

        //initialize game with as many cards as buttons
        self.game = MemoryGameSet(memoryButtons.count)
        
        //get the images for the game loaded up
        let nbrOfCards = fillImageSet()
        if nbrOfCards != memoryButtons.count{
            print ("Warning: image set size does not match number of buttons")
        }

        //make them look nice
        for view in gameView.subviews{
            view.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        }
        for subView in view.subviews{
            if subView is UIButton {
                //button.backgroundColor = UIColor.clearColor()
                subView.layer.cornerRadius = 10
                subView.layer.borderWidth = 0.2
                subView.mask?.clipsToBounds = true
                subView.layer.borderColor = UIColor.gray.cgColor
            } else{
                if subView is UIStackView{
                    for stackViews in subView.subviews{
                        for view in stackViews.subviews{
                            let button = view as! UIButton
                            button.layer.cornerRadius = 10
                            button.layer.borderWidth = 0.2
                            button.mask?.clipsToBounds = true
                            button.layer.borderColor = UIColor.gray.cgColor
                            button.setImage(UIImage(named: "cardback"), for: UIControl.State.normal)
                            button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
                        }
                    }
                }
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
    @IBAction func touchCard(_ sender: UIButton) {

        let index = memoryButtons.index(of: sender)
        
        if index != nil{
            game.cardTouch(cardIndex: index!)
            flipCountDisplay.text = "umgedrehte Karten: \(game.flipCount)"
            matchLabel.text = "Treffer: \(game.matchCount)"
            gameScore.text = "Score: \(game.gameScore)"

            for cardIndex in game.gameSet.indices{
                if game.gameSet[cardIndex].faceUp{
                    UIView.transition(with: sender,
                                      duration: 0.6,
                                      options: [.transitionFlipFromLeft],
                                      animations: {
                                        self.memoryButtons[cardIndex].setImage(self.imageSet[cardIndex], for: UIControl.State.normal)
                                        self.memoryButtons[cardIndex].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                                      })
                } else{
                    if !game.gameSet[cardIndex].matched{
                        memoryButtons[cardIndex].setImage(blankImage, for: UIControl.State.normal)
                        memoryButtons[cardIndex].setImage(UIImage(named: "cardback"), for: UIControl.State.normal)
                        memoryButtons[cardIndex].backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
                    }
                }
            }
            
            _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in self.hideMatchedPairs()})
        }
    }
    

    @IBAction func newGame(_ sender: UIButton) {
        game.newGame(nbrOfCards: memoryButtons.count)
        _ = fillImageSet()
        shuffle()
        for button in memoryButtons {
            button.setImage(UIImage(named: "cardback"), for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        }
        
    }
    
  
    //******************************
    //  MARK: class methods
    //******************************
    
    private func hideMatchedPairs(){
        print("about to hide the matched pairs")
        for cardIndex in game.gameSet.indices{
            if game.gameSet[cardIndex].matched{
                memoryButtons[cardIndex].setImage(blankImage, for: UIControl.State.normal)
                memoryButtons[cardIndex].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }
        
    }
    
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

        //and now copy the cards to have two of each for matching
        for index in 0...imageSet.count-1 {
            imageSet.append(imageSet[index])
        }
        shuffle()
        return imageSet.count
    }
    private func shuffle(){
        var last = imageSet.count - 1
        while last > 0 {
            let rnd = last.arc4Random
            imageSet.swapAt(last, rnd)
            game.gameSet.swapAt(last, rnd)
            last -= 1
        }
    }
}

extension Int {
    var arc4Random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
