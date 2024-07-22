//
//  UIFont + Extensions.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

extension UIFont {

    enum FontType {
        case pingFangBold
        case pingFangMedium
        case pingFangRegular
        case sfproRegular
        case sfproMedium
        case sfproBold
    }

    enum PingFangWeight: String {
        case Regular  = "PingFangTC-Regular"
        case Medium   = "PingFangTC-Medium"
        case Semibold = "PingFangTC-Semibold"
    }

    static func font(_ fontType: FontType, fontSize size: CGFloat) -> UIFont {
        switch fontType {
        case .pingFangBold:
            return UIFont(name: PingFangWeight.Semibold.rawValue, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        case .pingFangMedium:
            return UIFont(name: PingFangWeight.Medium.rawValue, size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        case .pingFangRegular:
            return UIFont(name: PingFangWeight.Regular.rawValue, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        case .sfproRegular:
            return UIFont.systemFont(ofSize: size, weight: .regular)
        case .sfproMedium:
            return UIFont.systemFont(ofSize: size, weight: .medium)
        case .sfproBold:
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
}

