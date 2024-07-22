//
//  DataLoader.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import Foundation
import Combine

protocol DataLoaderProvider {
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> AnyPublisher<T, DataError>
}

class DataLoader {
    static let shared = DataLoader()
    
    private init() {}
}

extension DataLoader: DataLoaderProvider {
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> AnyPublisher<T, DataError> {
            Future { promise in
                guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
                    print("File not found: \(filename)")
                    promise(.failure(.fileNotFound(filename)))
                    return
                }
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(T.self, from: data)
                    promise(.success(jsonData))
                } catch {
                    promise(.failure(DataError.decodeFailed(error)))
                }
            }
            .eraseToAnyPublisher()
        }
}
