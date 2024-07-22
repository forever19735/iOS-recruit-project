//
//  Hahow_iOS_RecruitTests.swift
//  Hahow-iOS-RecruitTests
//
//  Created by Tommy Lin on 2021/10/5.
//

import XCTest
import Combine
@testable import Hahow_iOS_Recruit

class Hahow_iOS_RecruitTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadJSONSuccess() {
        let expectation = self.expectation(description: "Loading JSON should succeed")

        let filename = "articles"
        
        DataLoader.shared.loadJSON(filename: filename, type: ArticlesData.self)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Loading JSON failed with error: \(error)")
                }
            }, receiveValue: { response in
                XCTAssertNotNil(response, "Response should not be nil")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadJSONFailure() {
        let expectation = self.expectation(description: "Loading JSON should fail")

        let filename = "invalidFile"
        
        DataLoader.shared.loadJSON(filename: filename, type: ArticlesData.self)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error, "Error should not be nil")
                    expectation.fulfill()
                } else {
                    XCTFail("Loading JSON should have failed")
                }
            }, receiveValue: { _ in
                XCTFail("Expected no value, but got some")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
}
