//
//  DetailTest.swift
//  ZemogaTests
//
//  Created by Jorge Azurduy on 10/4/22.
//

import XCTest

@testable import Zemoga

final class DetailTest: XCTestCase {

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
    
    private func setupExpectedAuthor() -> Author {
        let company = Company(name: "Romaguera-Crona", catchPhrase: "Multi-layered client-server neural-net", bs: "harness real-time e-markets")
        let geo = Geo(lat: "-37.3159", lng: "81.1496")
        let address = Address(street: "Kulas Light", suite: "Apt. 556", city: "Gwenborough", zipcode: "92998-3874", geo: geo)
        let expectedAuthor = Author(id: 1, name: "Leanne Graham", username: "Bret", email: "Sincere@april.biz", address: address, phone: "1-770-736-8031 x56442", website: "hildegard.org", company: company)
        
        return expectedAuthor
    }

    func testRequesAuthorDataFromServer() {
        // Given
       
        let expectedAuthor = setupExpectedAuthor()
        var expectedError: Error?
        
        // When
        let promise = self.expectation(description: "Status code: 200")
        
        sut.requestAuthor(authorId: 1, parameters: "") { response in
            switch response {
            case .success(let value):
                    XCTAssertEqual(value.username, expectedAuthor.username)
                    XCTAssertEqual(value.phone, expectedAuthor.phone)
                    XCTAssertEqual(value.address.street, expectedAuthor.address.street)
                    XCTAssertEqual(value.website, expectedAuthor.website)
                promise.fulfill()
            case .failure(let error):
                expectedError = error
            }
        }
        //wait(for: [promise], timeout: 2)

        waitForExpectations(timeout: 10, handler: .none)
        
        // Then
        XCTAssertNil(expectedError)
    }
    
    func testRequeCommentDataFromServer() {
        // Given
       
        let expectedComment = Comment(postId: 1,
                                      id: 3,
                                      name: "odio adipisci rerum aut animi",
                                      email: "Nikita@garfield.biz", body: "quia molestiae reprehenderit quasi aspernatur\naut expedita occaecati aliquam eveniet laudantium\nomnis quibusdam delectus saepe quia accusamus maiores nam est\ncum et ducimus et vero voluptates excepturi deleniti ratione")
        var expectedError: Error?
        
        // When
        let promise = self.expectation(description: "Status code: 200")
        
        sut.requestComments(postId: 1, parameters: "") { response in
            switch response {
            case .success(let value):
                    XCTAssertEqual(value[2].id, expectedComment.id)
                    XCTAssertEqual(value[2].name, expectedComment.name)
                    XCTAssertEqual(value[2].email, expectedComment.email)
                promise.fulfill()
            case .failure(let error):
                expectedError = error
            }
        }
        //wait(for: [promise], timeout: 2)

        waitForExpectations(timeout: 10, handler: .none)
        
        // Then
        XCTAssertNil(expectedError)
    }

}
