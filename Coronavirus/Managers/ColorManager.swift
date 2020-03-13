//
//  ColorManager.swift
//  Coronavirus
//
//  Created by Apple on 3/13/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit

class ColorManager {
    
    static let highColor: UIColor = .init(red: 1.0, green: 69.0 / 255, blue: 58.0 / 255, alpha: 1.0) // systemRed (dark)
    static let mediumColor: UIColor = .init(red: 1.0, green: 159.0 / 255, blue: 10.0 / 255, alpha: 1.0) // systemOrange (dark)
    static let lowColor: UIColor = .init(red: 1.0, green: 214.0 / 255, blue: 10.0 / 255, alpha: 1.0) // systemYellow (dark)
    static let normalColor: UIColor = .init(red: 50.0 / 255, green: 215.0 / 255, blue: 75.0 / 255, alpha: 1.0) // systemGreen (dark)
    
    static let headerBackgroundColor: UIColor = .init(red: 72.0 / 255, green: 72.0 / 255, blue: 74.0 / 255, alpha: 1.0) // systemGrey3 (dark)
    static let footerTextColor: UIColor = .systemGray
    
    static func getColorFrom(infected: Int) -> UIColor {
        if infected >= 10000 {
            return highColor
        } else if infected >= 1000 {
            return mediumColor
        } else if infected >= 200 {
            return lowColor
        }
        return normalColor
    }
}
