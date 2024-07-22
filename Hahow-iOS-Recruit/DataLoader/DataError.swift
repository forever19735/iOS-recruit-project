//
//  DataError.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import Foundation

enum DataError: Error {
    case decodeFailed(Error)
    case fileNotFound(String)
}
