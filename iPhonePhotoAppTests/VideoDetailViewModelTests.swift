//
//  VideoDetailViewModelTests.swift
//  iPhonePhotoAppTests
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import XCTest
@testable import iPhonePhotoApp

class VideoDetailViewModelTests: XCTestCase {

    var sut: VideoDetailViewModel!
    var mockAPIManager: MockApiManager!

    override func setUpWithError() throws {
        mockAPIManager = MockApiManager()
        sut = VideoDetailViewModel(downloadManager: DownloadManager())
        sut.dataManager = mockAPIManager
    }

    func testGetCurrentVideo() {
        XCTAssertEqual(sut.getCurrentVideo(), nil)
    }

    func testDownloadVideoSuccess() {
        mockAPIManager.completeVideos = VideoResponse(videos: testData)
        sut.downloadVideo()
        mockAPIManager.fetchSuccess()
    }

    func testDownloadVideoFailure() {
    }

}
