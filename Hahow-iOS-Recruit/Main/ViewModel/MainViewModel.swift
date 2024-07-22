//
//  MainViewModel.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import Combine
import Foundation

class MainViewModel {
    @Published private(set) var coursesData: [CoursesData]? = []
    @Published private(set) var articlesData: ArticlesData?
    
    private(set) var errorMessage = PassthroughSubject<DataError, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var dataLoader: DataLoader
    
    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
}

extension MainViewModel {
    func getDatas() {
        let coursesPublisher = dataLoader.loadJSON(filename: "courses", type: [CoursesData].self)
        let articlesPublisher = dataLoader.loadJSON(filename: "articles", type: ArticlesData.self)
        
        Publishers.Zip(coursesPublisher, articlesPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage.send(error)
                }
            }, receiveValue: { [weak self] courses, articles in
                self?.coursesData = courses
                self?.articlesData = articles
            })
            .store(in: &cancellables)
    }
}
