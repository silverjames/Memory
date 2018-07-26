//
//  MemoryView.swift
//  Memory
//
//  Created by Bernhard F. Kraft on 17.07.18.
//  Copyright © 2018 Bernhard F. Kraft. All rights reserved.
//

import UIKit

protocol cardViewDataSource: class {
    func getGridDimensions() -> (cellCount: Int, aspectRatio: CGFloat)
    func getCurrentDeck() -> [MemoryCard]
    func getImageSet() -> [UIImage]
}

class MemoryView: UIView {

    //    *****************
    //    MARK: properies
    //    *****************
    weak var delegate:cardViewDataSource?
    var gameButtons = [Int:UIButton]()
    var grid = Grid(layout: .dimensions(rowCount: 1, columnCount: 1))
    static let insets = CGFloat(6.0)
    private let buttonInset = UIEdgeInsets.init(top: insets, left: insets, bottom: insets, right: insets)
    var animator:UIViewPropertyAnimator!

    //    *****************
    //    MARK: lifecycle functions
    //    *****************
    override func layoutSubviews() {
        print ("mv:layoutSubviews")
        super.layoutSubviews()

        if let _ = animator {
            if !animator.isRunning {
                updateViewFromModel()
            }
        } else{
            updateViewFromModel()
        }
    }

    //    *****************
    //    MARK: class functions
    //    *****************
//    override func draw(_ rect: CGRect) {
//
//        // Drawing code
//}
    func updateViewFromModel(){
        
        self.grid = Grid(layout: .aspectRatio(delegate!.getGridDimensions().aspectRatio))
        grid.cellCount = (delegate!.getGridDimensions().cellCount)
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        gameButtons.removeAll()
        grid.frame = self.bounds

        for idx in 0 ..< grid.cellCount {
            let button = UIButton()
            button.frame = grid[idx]!.inset(by: buttonInset)

            switch delegate!.getCurrentDeck()[idx].state{

            case .faceDown:
                formatFaceDownCard(button: button)
                button.isHidden = false

            case .faceUp:
                formatFaceUpCard(button: button, atIndex: idx)
                button.isHidden = false
                
            case .matched:
                formatFaceUpCard(button: button, atIndex: idx)
                button.isHidden = true
            }//switch
            
            button.addTarget(delegate, action: Selector(("touchCard:")), for: .touchUpInside)
            self.addSubview(button)
            gameButtons[(delegate?.getCurrentDeck()[idx].id)!] = button
        }

    }
    
    func formatFaceDownCard(button: UIButton){
//        button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 0.4
        button.mask?.clipsToBounds = true
        button.imageView?.contentMode = .scaleToFill
        button.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        UIView.transition(with: button, duration: 0.5, options: [.transitionFlipFromRight], animations: {
            button.setImage(UIImage(named: "cardback"), for: UIControl.State.normal)
            })
    }
    
    func formatFaceUpCard(button: UIButton, atIndex:Int){
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 2.0
        button.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        button.imageView?.contentMode = .scaleToFill
        button.mask?.clipsToBounds = true
        UIView.transition(with: button, duration: 0.6, options: [.transitionFlipFromLeft],
            animations: {
                let image = self.delegate!.getImageSet()[self.delegate!.getCurrentDeck()[atIndex].designation]
                button.setImage(image.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0), for: UIControl.State.normal)
                })
    }
    
    func amimateAndHideMatchedPair(keys: [Int]){
        
        animator = UIViewPropertyAnimator.init(duration: 3, curve: .easeOut, animations: {
            [unowned self, keys] in
            keys.forEach{
                self.gameButtons[$0]?.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
                self.gameButtons[$0]?.alpha = 0
                }
        })
        
        animator.startAnimation()

    }// end func

}
