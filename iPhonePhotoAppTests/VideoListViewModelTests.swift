//
//  VideoListViewModelTests.swift
//  iPhonePhotoAppTests
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import XCTest
@testable import iPhonePhotoApp

class VideoListViewModelTests: XCTestCase {

    var sut: VideoListViewModel!
    var mockAPIManager: MockApiManager!

    override func setUpWithError() throws {
        mockAPIManager = MockApiManager()
        sut = VideoListViewModel(dataManager: mockAPIManager)
    }

    func testFetchVideos() {
        sut.fetchVideos()
        XCTAssert(mockAPIManager.isFetchVideosCalled)
    }

    func testFetchVideosSuccess() {
        mockAPIManager.completeVideos = VideoResponse(videos: testData)
        sut.fetchVideos()
        mockAPIManager.fetchSuccess()

        XCTAssert(!sut.videos.isEmpty)
        XCTAssert(!sut.isLoading)
        XCTAssert(!sut.returnedError)
        XCTAssert(sut.errorMessage == nil)
    }

    func testFetchVideosFailure() {
        sut.fetchVideos()
        mockAPIManager.fetchFail()
        XCTAssert(!sut.isLoading)
        XCTAssert(sut.returnedError)
        XCTAssert(sut.errorMessage != nil)
    }

}
