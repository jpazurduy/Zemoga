//
//  ZemogaTests.swift
//  ZemogaTests
//
//  Created by Jorge Azurduy on 10/3/22.
//

import XCTest

@testable import Zemoga

final class PostTest: XCTestCase {

    var sut: NetworkManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try  super.setUpWithError()
        sut = NetworkManager.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testRequestPostDataFromServer() {
        // Given
        let expectedPost: Post = Post(userId: 1,
                                       id: 1,
                                       title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                                       body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
        var expectedError: Error?
        
        // When
        let promise = self.expectation(description: "Status code: 200")
        
        sut.requestPosts(parameters: "") { response in
            switch response {
            case .success(let value):
                XCTAssertEqual(value[0].id, expectedPost.id)
                XCTAssertEqual(value[0].title, expectedPost.title)
                promise.fulfill()
            case .failure(let error):
                expectedError = error
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10, handler: .none)
        
        // Then
        XCTAssertNil(expectedError)
    }
}
