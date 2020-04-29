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

    func testUpdateAndFetchDownloadedVideoLocation() throws {
        let testLocation = "file:///private/var/mobile/Containers/Data/Application/3DA266C4-2A85-46AC-BE7A-3C97DC288E76/"
        let requestExpectation = expectation(description: "Save and Retrieve saved Video Location")
        do {
            try sut.updateVideo(video: testData[0], downloadLocation: testLocation)

            let retrievedLocation = try sut.getDownloadedLocation(video: testData[0])

            XCTAssertEqual(testLocation, retrievedLocation)
            requestExpectation.fulfill()
        } catch RuntimeError.NoRealmSet {
            XCTAssert(false, "No realm DB was set")
        } catch  {
            XCTAssert(false, "Unexpected Error: \(error)")
        }

        wait(for: [requestExpectation], timeout: 10.0)
    }

}
