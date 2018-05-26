//
//  MemoryViewController.swift
//  Memory
//
//  Created by Bernhard F. Kraft on 20.05.18.
//  Copyright © 2018 Bernhard F. Kraft. All rights reserved.
//

import UIKit

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

        game.cardTouch(cardIndex: memoryButtons.index(of: sender)!)
        flipCard(index: memoryButtons.index(of: sender)!, on: sender)
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame(nbrOfCards: memoryButtons.count)
        shuffleImages()
        for button in memoryButtons {
            button.setImage(blankImage, for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        }
        
    }
    
  
    //******************************
    //  MARK: class methods
    //******************************


    func flipCard(index: Int, on button: UIButton) {
        if game.gameSet[index].faceUp {
            button.setImage(blankImage, for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            game.gameSet[index].faceUp = false
        } else {
            button.setImage(imageSet[index], for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
            game.gameSet[index].faceUp = true
        }
    }
    
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
        shuffleImages()
        return imageSet.count
    }
    private func shuffleImages(){
        var last = imageSet.count - 1
        while last > 0 {
            let rand = Int(arc4random_uniform(UInt32(last)))
            imageSet.swapAt(last, rand)
            last -= 1
        }
    }

}
extension Collection {
    
}


