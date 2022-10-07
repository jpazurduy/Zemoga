//
//  ZemogaTests.swift
//  ZemogaTests
//
//  Created by Jorge Azurduy on 10/3/22.
//

import XCTest

@testable import Zemoga

final class PostTest: XCTestCase {

    var sut: URLSession!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try  super.setUpWithError()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testValidationAPICallPostDataFromServer() {
        // Given
        let url = URL(string: Path.posts)!
        var expectedError: Error?
        
        // When
        let promise = self.expectation(description: "Status code: 200")
        
        let dataTask = sut.dataTask(with: url) { _, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()

        waitForExpectations(timeout: 10, handler: .none)
        
        // Then
        XCTAssertNil(expectedError)
    }
    
    func testRequestPostDataFromServer() {
        // Given
        let url = URL(string: Path.posts)!
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let expectedPost: Post = Post(id: 1,
                                      userId: 1,
                                      title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                                      body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
                                      context: context)
        var expectedError: Error?
        
        // When
        let promise = self.expectation(description: "Status code: 200")
        
        let dataTask = sut.dataTask(with: url) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    
                    guard let data = data else {
                        XCTFail("Status code: \(statusCode)")
                        return
                    }
                                
                    do {
                        let decoder = JSONDecoder()
                        decoder.userInfo[CodingUserInfoKey.context!] = PersistanceManager.shared.container.viewContext
                        let decode = try decoder.decode([Post].self, from: data)
                        
                        XCTAssertEqual(decode[0].id, expectedPost.id)
                        XCTAssertEqual(decode[0].title, expectedPost.title)
                        promise.fulfill()

                    } catch {
                        XCTFail("Decoding error")
                    }
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        
//        sut.requestPosts(parameters: "") { response in
//            switch response {
//            case .success(let value):
//                XCTAssertEqual(value[0].id, expectedPost.id)
//                XCTAssertEqual(value[0].title, expectedPost.title)
//                promise.fulfill()
//            case .failure(let error):
//                expectedError = error
//                XCTFail(error.localizedDescription)
//            }
//        }

        waitForExpectations(timeout: 10, handler: .none)
        
        // Then
        XCTAssertNil(expectedError)
    }
}
