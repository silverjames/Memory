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

    var blankImage:UIImage? = nil
    lazy var game = MemoryGameSet(1)
    var imageSet:[UIImage] = []

    @IBOutlet var gameView: UIView!
    @IBOutlet var memoryButtons: [UIButton]!
    @IBOutlet weak var flipCountDisplay: UILabel!
    
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
        for button in view.subviews{
            if button is UIButton {
                //button.backgroundColor = UIColor.clearColor()
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 0.1
                button.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }
    
    //******************************
    //  MARK: button actions
    //******************************
    @IBAction func touchCard(_ sender: UIButton) {

        var status = (true, true, true, 999, 999)
        let index = memoryButtons.index(of: sender)
        
        if index != nil{
            status = game.cardTouch(cardIndex: index!)
        
            switch status {
            case (true, false, false, _, _):
                print("vc:first turn detected")
                print("card with index \(String(describing: index))and \(game.gameSet[index!].id) id")
                sender.setImage(imageSet[index!], for: UIControlState.normal)
                sender.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)

            case (false, true, false, let index0, let index1):
                print("vc:unmatched pair detected")
                print("card 1 with index \(String(describing: index0))and id \(game.gameSet[index0].id)")
                print("card 2 with index \(String(describing: index1))and id \(game.gameSet[index1].id)")
                memoryButtons[index0].setImage(imageSet[index0], for: UIControlState.normal)
                memoryButtons[index1].setImage(imageSet[index1], for: UIControlState.normal)
                memoryButtons[index0].backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                memoryButtons[index1].backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                _ = Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: {_ in self.releaseMismatchedPair(cardIndex0: index0, cardIndex1: index1)})
                
            case (false, false, true, let index0, let index1):
                print("vc:match detected")
                print("card 1 with index \(String(describing: index0))and id \(game.gameSet[index0].id)")
                print("card 2 with index \(String(describing: index1))and id \(game.gameSet[index1].id)")
                memoryButtons[index0].setImage(imageSet[index0], for: UIControlState.normal)
                memoryButtons[index1].setImage(imageSet[index1], for: UIControlState.normal)
                memoryButtons[index0].backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                memoryButtons[index1].backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                _ = Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: {_ in self.hideMatchedPair(cardIndex0: index0, cardIndex1: index1)})

            default:
                print("vc:touchCard: undefined status")
            }
        }
    }
    
    func releaseMismatchedPair(cardIndex0: Int, cardIndex1: Int){
        print("about to turn back over the mismatched pair")
        memoryButtons[cardIndex0].setImage(blankImage, for: UIControlState.normal)
        memoryButtons[cardIndex1].setImage(blankImage, for: UIControlState.normal)
        memoryButtons[cardIndex0].backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        memoryButtons[cardIndex1].backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        game.gameSet[cardIndex0].faceUp = false
        game.gameSet[cardIndex1].faceUp = false
    }

    func hideMatchedPair(cardIndex0: Int, cardIndex1: Int){
        print("about to hide the matched pair")
        memoryButtons[cardIndex0].setImage(blankImage, for: UIControlState.normal)
        memoryButtons[cardIndex1].setImage(blankImage, for: UIControlState.normal)
        memoryButtons[cardIndex0].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        memoryButtons[cardIndex1].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }

    @IBAction func newGame(_ sender: UIButton) {
        game.newGame(nbrOfCards: memoryButtons.count)
        shuffle()
        for button in memoryButtons {
            button.setImage(blankImage, for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        }
        
    }
    
  
    //******************************
    //  MARK: class methods
    //******************************
    
    private func fillImageSet() -> Int {
        //  creates one entry for each image - would be nicer if I could find a way to iterate through the available images
        imageSet.append(UIImage(named: "Bernhard")!)
        imageSet.append(UIImage(named: "Ildiko")!)
        imageSet.append(UIImage(named: "Kathi")!)
        imageSet.append(UIImage(named: "Marie")!)
        imageSet.append(UIImage(named: "Teresa")!)
        imageSet.append(UIImage(named: "Juliana")!)
        
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
            let rand = Int(arc4random_uniform(UInt32(last)))
            imageSet.swapAt(last, rand)
            game.gameSet.swapAt(last, rand)
            last -= 1
        }
    }
}
//fileprivate extension Selector {
//    static let turnBackPair =
//        #selector(turnBackPair())
//}

