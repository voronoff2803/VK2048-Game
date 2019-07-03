//
//  gameView.swift
//  VK2048
//
//  Created by Alexey Voronov on 18/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import Foundation
import UIKit

class GameView: UIView {
    let appearance: AppearanceProtocol
    let size: Int
    var tiles: [TileView] = []
    var delegate: GameViewDelegate?
    var sideSize: CGFloat = 0
    
    init(frame: CGRect, size: Int, appearance: AppearanceProtocol) {
        self.appearance = appearance
        self.size = size
        super.init(frame: frame)
        self.sideSize = min(frame.width, frame.height)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupBackgroundTiles()
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(sender:)))
            gesture.direction = direction
            self.addGestureRecognizer(gesture)
        }
        startGame()
    }
    
    func setupBackgroundTiles() {
        for x in 0...size - 1 {
            for y in 0...size - 1 {
                let tileSize = self.sideSize / CGFloat(self.size) * 0.85
                let coordinateX = self.sideSize / (CGFloat(self.size) + 0.2) * (CGFloat(x) + 0.6)
                let coordinateY = self.sideSize / (CGFloat(self.size) + 0.2) * (CGFloat(y) + 0.6)
                let tile = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: tileSize, height: tileSize)))
                tile.center = CGPoint(x: coordinateX, y: coordinateY)
                tile.layer.zPosition = -2
                tile.layer.cornerRadius = appearance.cornerRadius()
                tile.backgroundColor = appearance.backgroundTileColor()
                self.addSubview(tile)
            }
        }
    }
    
    func startGame() {
        self.isUserInteractionEnabled = true
        self.tiles.forEach() {$0.removeFromSuperview()}
        self.tiles = []
        
        if !self.loadState() {
            addTile()
            addTile()
        }
    }
    
    func looseGame() {
        self.isUserInteractionEnabled = false
        self.delegate?.looseAction()
    }
    
    func saveState() {
        var tilesForSave: [[String: Any]] = []
        for tile in self.tiles {
            tilesForSave.append(["value": tile.value, "x": tile.x, "y": tile.y])
        }
        UserDefaults.standard.set(tilesForSave, forKey: "tiles")
    }
    
    func removeSave() {
        UserDefaults.standard.set(nil, forKey: "tiles")
    }
    
    func loadState() -> Bool {
        if let loadedTiles = UserDefaults.standard.array(forKey: "tiles") as? [[String: Any]] {
            for tile in loadedTiles {
                let value = tile["value"]  as! Int
                let x = tile["x"] as! Int
                let y = tile["y"] as! Int
                addTile(x: x, y: y, value: value)
            }
            return true
        } else {
            return false
        }
    }
    
    func sheck() {
        if tiles.count == size * size {
            var isLoose = true
            for tile in tiles {
                if let leftTile = tiles.first(where: {$0.x == tile.x && $0.y == tile.y - 1}) {
                    if leftTile.value == tile.value {
                        isLoose = false
                    }
                }
                if let rightTile = tiles.first(where: {$0.x == tile.x && $0.y == tile.y + 1}) {
                    if rightTile.value == tile.value {
                        isLoose = false
                    }
                }
                if let upTile = tiles.first(where: {$0.x == tile.x - 1 && $0.y == tile.y}) {
                    if upTile.value == tile.value {
                        isLoose = false
                    }
                }
                if let downTile = tiles.first(where: {$0.x == tile.x + 1 && $0.y == tile.y}) {
                    if downTile.value == tile.value {
                        isLoose = false
                    }
                }
            }
            if isLoose {
                self.looseGame()
            }
        }
    }
    
    func addTile(x: Int, y: Int, value: Int = Int.random(in: 1...2) * 2) {
        let tileSize = self.frame.width / CGFloat(self.size) * 0.85
        let tile = TileView(size: tileSize, appearance: self.appearance, x: x, y: y, value: value, gameView: self)
        self.tiles.append(tile)
        self.addSubview(tile)
    }
    
    func addTile() {
        var arrayIndex = Array(0...size * size - 1)
        tiles.forEach { (tile) in
            arrayIndex.removeAll() {$0 == tile.x * size + tile.y}
        }
        let elem = arrayIndex.randomElement()!
        addTile(x: elem / size, y: elem % size)
    }
    
    @objc func swipeAction(sender: UISwipeGestureRecognizer) {
        self.move(direction: sender.direction)
    }
    
    func moveTile(tile: TileView, x: Int, y: Int) {
        tile.move(x: x, y: y)
    }
    
    func move(direction: UISwipeGestureRecognizer.Direction) {
        var xRange: [Int] = []
        var yRange: [Int] = []
        var offset: Int = 0
        var wall: Int = 0
        var isHorisontal: Bool = false
        var isMoved: Bool = false
        
        switch direction {
        case .up:
            isHorisontal = false
            wall = 0
            offset = 1
            xRange = Array(0...self.size - 1)
            yRange = Array(0...self.size - 1)
        case .down:
            isHorisontal = false
            wall = size - 1
            offset = -1
            xRange = Array(0...self.size - 1)
            yRange = Array(0...self.size - 1).reversed()
        case .left:
            isHorisontal = true
            wall = 0
            offset = 1
            xRange = Array(0...self.size - 1)
            yRange = Array(0...self.size - 1)
        case .right:
            isHorisontal = true
            wall = size - 1
            offset = -1
            xRange = Array(0...self.size - 1).reversed()
            yRange = Array(0...self.size - 1)
        default:
            fatalError("wrong swipe direction!")
        }
        
        if isHorisontal {
            for y in yRange {
                var lastTile: TileView? = nil
                var lastTileX: Int = wall
                for x in xRange {
                    if let tile = self.tiles.first(where: {$0.x == x && $0.y == y}) {
                        if tile.value  == lastTile?.value {
                            tile.move(x: lastTile!.x, y: lastTile!.y)
                            tile.remove()
                            lastTile!.add()
                            self.tiles.removeAll() {$0 == tile}
                            lastTileX = lastTile!.x + offset
                            lastTile = nil
                            isMoved = true
                        } else {
                            if tile.x != lastTileX || tile.y != y {
                                isMoved = true
                                tile.move(x: lastTileX, y: y)
                            }
                            lastTileX += offset
                            lastTile = tile
                        }
                    }
                }
            }
        } else {
            for x in xRange {
                var lastTile: TileView? = nil
                var lastTileY: Int = wall
                for y in yRange {
                    if let tile = self.tiles.first(where: {$0.x == x && $0.y == y}) {
                        if tile.value  == lastTile?.value {
                            tile.move(x: lastTile!.x, y: lastTile!.y)
                            tile.remove()
                            lastTile!.add()
                            self.tiles.removeAll() {$0 == tile}
                            lastTileY = lastTile!.y + offset
                            lastTile = nil
                            isMoved = true
                        } else {
                            if tile.x != x || tile.y != lastTileY {
                                isMoved = true
                                tile.move(x: x, y: lastTileY)
                            }
                            lastTileY += offset
                            lastTile = tile
                        }
                    }
                }
            }
        }
        if isMoved {
            self.addTile()
            self.sheck()
            self.saveState()
        }
    }
}

protocol GameViewDelegate {
    func looseAction()
}
