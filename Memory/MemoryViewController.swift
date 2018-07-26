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
    private var cardPiles:[UIImageView] = []
    private var selectedCards = [Int:Int]() //key: card ID, value: card index in deck
    private var nbrOfCards:Int {
        get{
            return imageSet.count * 2
        }
    }
    private var gameFinished: Bool {
        return (nbrOfCards/2 == game?.matchCount) ?  true :  false
    }
    private var animator:UIViewPropertyAnimator!
    
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
        return (game!.gameSet.count, CGFloat(Constants.defaultAspectRatio))
    }
    func getCurrentDeck() -> [MemoryCard] {
        return self.game!.gameSet
    }
    func getImageSet() -> [UIImage] {
        return imageSet
    }
    func getDiscardPileFrame() -> CGRect {
        return cardPiles[1].frame
    }

    //******************************
    //  MARK: lifecycle function overrides
    //******************************
    override func viewDidLoad() {
        super.viewDidLoad()

//        flipCountDisplay.text = nil
//        matchLabel.text = nil
//        gameScore.text = nil
//
        selectedCards.removeAll()
        fillImageSet()  //get the images for the game loaded up
        game = MemoryGameSet(nbrOfCards)   //initialize game with as many cards as we have
       
        for subView in view.subviews{  //make them look nice
            if subView is UIButton {
                //button.backgroundColor = UIColor.clearColor()
                subView.layer.cornerRadius = 8
                subView.layer.borderWidth = 0.4
                subView.layer.borderColor = UIColor.gray.cgColor
            }
            if subView is UILabel{
                subView.layer.cornerRadius = 10
                subView.layer.borderWidth = 0.2
                subView.layer.borderColor = UIColor.gray.cgColor
                subView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
            if subView is UIImageView{
                cardPiles.append(subView as! UIImageView)
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
        
        switch selectedCards.count{
                
            case 0:
                if cardButton != nil{
                    selectedCards[cardButton!.key] = idx!
                    game!.gameSet[idx!].state = .faceUp
                    cardView.formatFaceUpCard(button: sender, atIndex: idx!)
                    game?.flipCount += 1
//                    finishGame() //MARK: debug
                }
            
            case 1:
                if cardButton?.key != selectedCards.first?.key {//skip this if user clicked the one facteup card again (fool)
                    if cardButton != nil  {
                        selectedCards[cardButton!.key] = idx
                        game!.gameSet[idx!].state = .faceUp
                        cardView.formatFaceUpCard(button: sender, atIndex: idx!)
                        game?.flipCount += 1
                    }
                    
                    let keys = selectedCards.map({$0.key})
                    let indices = selectedCards.map {$0.value}
                    if game!.match(keys: indices){
                        print("cards matched!")
                        indices.forEach{game!.gameSet[$0].state = .matched}
                        game?.matchCount += 1
                        game?.score += Constants.matchPoints
                        cardView.amimateAndHideMatchedPair(keys: keys)
                        selectedCards.removeAll()
                        if gameFinished {
                            finishGame()
                        }
                    } else {
                        print("cards did not match!")
                        game?.score += Constants.mismatchPoints
                        _ = Timer.scheduledTimer(withTimeInterval: Constants.timerInterval, repeats: false, block: {_ in self.turnBackCards(keys: keys, indices: indices)})
                    }
                }
                
            default:
                break

            }//switch
        updateCounters()
    }//func

    @IBAction func newGame(_ sender: UIButton) {
            resetGame()
    }
  
    //******************************
    //  MARK: class methods
    //******************************
    
    private func resetGame(){
        game!.newGame(nbrOfCards: nbrOfCards)
        updateCounters()
        cardView.setNeedsLayout()
    }
        
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
    
    private func finishGame(){

        //create a message label
        let labelWidth = self.view.bounds.width * 0.7
        let labelHeigth = self.view.bounds.height * 0.4
        let labelSize = CGSize(width: labelWidth, height: labelHeigth)
        let labelOrigin = gameView.bounds.origin
        let labelFrame = CGRect(origin: labelOrigin, size: labelSize)
        let label = UILabel(frame: labelFrame)
        label.center = gameView.center
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 0)
        label.alpha = 0
        gameView.addSubview(label)

        //create a message
        var attributes = [NSAttributedString.Key: Any?]()
        attributes = [.font:UIFont.preferredFont(forTextStyle: .body).withSize(88), .foregroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), .strokeWidth: -4.0]
        label.attributedText = NSAttributedString(string:"Game Over", attributes:attributes as [NSAttributedString.Key : Any])

        animator = UIViewPropertyAnimator.init(duration: 5, curve: .easeOut, animations: {
            [unowned self, label] in
            label.alpha = 1
            for subView in self.gameView.subviews{
                if subView is UIStackView{
                    subView.alpha = 0
                }
            }
        })
        
        animator.addCompletion({finished in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2.0, delay: 0, options: .curveEaseOut, animations: {
                [label] in
                label.alpha = 0
                }, completion:{finished in
                    label.removeFromSuperview()
                    self.resetGame()
                    for subView in self.gameView.subviews{
                        if subView is UIStackView{
                            subView.alpha = 1
                        }
                    }
                })
        })
        animator.startAnimation()
    }
    
    private func fillImageSet() {
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
    }

}

struct Constants {
    static let mismatchPoints = -2
    static let matchPoints = 5
    static let deselectPoints = -1
    static let defaultAspectRatio = 1.0
    static let timerInterval = 1.2
}

