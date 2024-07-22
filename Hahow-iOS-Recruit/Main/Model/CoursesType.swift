//
//  CoursesType.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

enum CoursesType: String {
    /// 募資中
    case incubating = "INCUBATING"
    /// 已開課
    case published = "PUBLISHED"

    var title: String {
        switch self {
        case .incubating:
            return "募資中"
        case .published:
            return "已開課"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .incubating:
            return UIColor(hex: "#F5BD57")
        case .published:
            return UIColor(hex: "#5CC9B5")
        }
    }
}
