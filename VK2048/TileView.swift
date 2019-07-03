//
//  Tile.swift
//  VK2048
//
//  Created by Alexey Voronov on 18/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import Foundation
import UIKit

class TileView: UIView {
    var value: Int
    var x: Int
    var y: Int
    private let gameView: GameView
    
    let appearance: AppearanceProtocol
    private let valueLabel = UILabel()
    
    init(size: CGFloat, appearance: AppearanceProtocol, x: Int, y: Int, value: Int, gameView: GameView) {
        self.gameView = gameView
        self.appearance = appearance
        self.value = value
        self.x = x
        self.y = y
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size, height: size)))
        self.center = coordinatesFrom(x: x, y: y)
        self.setup()
    }
    
    func setup() {
        self.layer.cornerRadius = self.appearance.cornerRadius()
        self.valueLabel.frame = self.bounds
        self.valueLabel.textAlignment = .center
        self.addSubview(valueLabel)
        self.setupAppearance()
    }
    
    func setupAppearance() {
        self.backgroundColor = self.appearance.tileColor(self.value)
        self.valueLabel.textColor = self.appearance.labelColor(self.value)
        self.valueLabel.font = self.appearance.fontSizeForNumbers(self.value)
        self.valueLabel.text = String(self.value)
    }
    
    func coordinatesFrom(x: Int, y: Int) -> CGPoint {
        let coordinateX = self.gameView.sideSize / (CGFloat(self.gameView.size) + 0.2) * (CGFloat(x) + 0.6)
        let coordinateY = self.gameView.sideSize / (CGFloat(self.gameView.size) + 0.2) * (CGFloat(y) + 0.6)
        return CGPoint(x: coordinateX, y: coordinateY)
    }
    
    func move(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.layer.zPosition = -1
        UIView.animate(withDuration: 0.15) {
            self.center = self.coordinatesFrom(x: x, y: y)
        }
    }
    
    override func didMoveToSuperview() {
        self.appeared()
    }
    
    func appeared() {
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    func add() {
        self.value += self.value
        self.layer.zPosition = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.setupAppearance()
            UIView.animate(withDuration: 0.08, animations: {
                self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }, completion: { (bool) in
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    func remove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

