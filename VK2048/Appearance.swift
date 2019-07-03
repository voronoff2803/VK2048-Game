//
//  Appearance.swift
//  VK2048
//
//  Created by Alexey Voronov on 18/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import Foundation
import UIKit

protocol AppearanceProtocol: class {
    func tileColor(_ value: Int) -> UIColor
    func labelColor(_ value: Int) -> UIColor
    func fontSizeForNumbers(_ value: Int) -> UIFont
    func cornerRadius() -> CGFloat
    func backgroundTileColor() -> UIColor
    func backgroundColor() -> UIColor
}

class NormalAppearance: AppearanceProtocol {
    func tileColor(_ value: Int) -> UIColor {
        switch value {
        case 2:
            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case 4:
            return UIColor(red: 225.0/255.0, green: 227.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        case 8:
            return UIColor(red: 155.0/255.0, green: 221.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        case 16:
            return UIColor(red: 96.0/255.0, green: 180.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        case 32:
            return UIColor(red: 38.0/255.0, green: 140.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        case 64:
            return UIColor(red: 16.0/255.0, green: 103.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        case 128:
            return UIColor(red: 10.0/255.0, green: 77.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        case 256:
            return UIColor(red: 29.0/255.0, green: 64.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        case 512:
            return UIColor(red: 14.0/255.0, green: 146.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        case 1024:
            return UIColor(red: 6.0/255.0, green: 36.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        case 2048:
            return UIColor(red: 18.0/255.0, green: 14.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        default:
            return UIColor(red: 18.0/255.0, green: 14.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        }
    }
    
    func labelColor(_ value: Int) -> UIColor {
        switch value {
        case 2, 4, 8, 16, 32:
            return UIColor.black
        default:
            return UIColor.white
        }
    }

    func fontSizeForNumbers(_ value: Int) -> UIFont {
        switch value {
        case 2, 4, 8, 16, 32, 64:
            return UIFont.systemFont(ofSize: 37, weight: .bold)
        default:
            return UIFont.systemFont(ofSize: 29, weight: .bold)
        }
    }
    
    func cornerRadius() -> CGFloat {
        return 12.0
    }
    
    func backgroundTileColor() -> UIColor {
        return UIColor(red: 184.0/255.0, green: 193.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    }
    
    func backgroundColor() -> UIColor {
        return UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    }
}
