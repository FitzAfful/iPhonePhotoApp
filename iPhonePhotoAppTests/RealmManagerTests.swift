//
//  RealmManagerTests.swift
//  iPhonePhotoAppTests
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import XCTest
@testable import iPhonePhotoApp

class RealmManagerTests: XCTestCase {

    var sut: RealmManager!

    override func setUpWithError() throws {
        sut = RealmManager()
    }

    func testSaveAndFetchVideos() throws {
        let requestExpectation = expectation(description: "Save and Retrieve saved Videos")
        do {
            try sut.saveVideos(videos: testData)

            try sut.fetchVideos { (result) in
                switch result {
                case .success(let response):
                    XCTAssertEqual(response.videos.count, 2)
                    XCTAssertEqual(response.videos[0], testData[0])
                    requestExpectation.fulfill()
                case .failure:
                    XCTFail()
                }
            }
        } catch RuntimeError.NoRealmSet {
            XCTAssert(false, "No realm DB was set")
        } catch  {
            XCTAssert(false, "Unexpected Error: \(error)")
        }

        wait(for: [requestExpectation], timeout: 10.0)
    }

}
