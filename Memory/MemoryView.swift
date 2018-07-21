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
    static let insets = CGFloat(6.0)
    private let buttonInset = UIEdgeInsets.init(top: insets, left: insets, bottom: insets, right: insets)

    //    *****************
    //    MARK: lifecycle functions
    //    *****************
    override func layoutSubviews() {
        print ("mv:layoutSubviews")
        super.layoutSubviews()
        
        var grid = Grid(layout: .aspectRatio(delegate!.getGridDimensions().aspectRatio))
        grid.cellCount = (delegate!.getGridDimensions().cellCount)
        
        for view in self.subviews{
            view.removeFromSuperview()
        }
        
        gameButtons.removeAll()
        
        grid.frame = self.bounds

        for idx in 0 ..< grid.cellCount {
            let button = UIButton()
            button.frame = grid[idx]!.inset(by: buttonInset)
            switch delegate!.getCurrentDeck()[idx].state{
                case .faceDown:
                    buttonFormatNotSelected(button: button)
                    button.isHidden = false
                case .faceUp:
                    buttonFormatSelected(button: button, atIndex: idx)
                    button.isHidden = false
                case .matched:
                    buttonFormatSelected(button: button, atIndex: idx)
                    button.isHidden = true
                }//switch

            button.addTarget(delegate, action: Selector(("touchCard:")), for: .touchUpInside)
            self.addSubview(button)
            gameButtons[(delegate?.getCurrentDeck()[idx].id)!] = button
//            print ("created button with id: \(String(describing: delegate?.getCurrentDeck()[idx].id))")
        }
    }

    //    *****************
    //    MARK: class functions
    //    *****************
    func buttonFormatNotSelected(button: UIButton){
        button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.2
        button.mask?.clipsToBounds = true
        button.layer.borderColor = UIColor.gray.cgColor
        button.setImage(UIImage(named: "cardback"), for: UIControl.State.normal)
    }
    
    func buttonFormatSelected(button: UIButton, atIndex:Int){
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 3.0
        button.mask?.clipsToBounds = true
        button.setImage(delegate!.getImageSet()[delegate!.getCurrentDeck()[atIndex].designation], for: UIControl.State.normal)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
