//
//  MyFindOrLoss001Tests.swift
//  MyFindOrLoss001Tests
//
//  Created by Mustafa Taşdemir on 22.01.2022.
//

import XCTest
import Combine
@testable import MyFindOrLoss001

class MyFindOrLoss001Tests: XCTestCase {

    var cancellable: AnyCancellable?
    var imageInfo: ImageMetadata?
    
    func testImagePublisher() async throws {
        //await Task.sleep(2_000_000_000)
        XCTAssertNotNil(imageInfo)
    }
    
    override func setUpWithError() throws {
        let publisher = try ImagePublisher()
        cancellable =
        publisher.imageUrlPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("\(error)")
                }
            }, receiveValue: { value in
                print(value)
                self.imageInfo = value
            })
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
