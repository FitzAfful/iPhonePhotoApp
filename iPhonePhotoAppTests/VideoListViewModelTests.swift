//
//  VideoListViewModelTests.swift
//  iPhonePhotoAppTests
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import XCTest
@testable import iPhonePhotoApp
@testable import RealmSwift

class VideoListViewModelTests: XCTestCase {

    var sut: VideoListViewModel!
    var mockAPIManager: MockApiManager!

    override func setUpWithError() throws {

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let config = Realm.Configuration(inMemoryIdentifier: self.name)
        _ = try! Realm.deleteFiles(for: config)
        let testRealm = try! Realm(configuration: config)
        let realmManager = RealmManager()
        realmManager.realm = testRealm

        mockAPIManager = MockApiManager()
        sut = VideoListViewModel(dataManager: mockAPIManager)
        sut.realmManager = realmManager
    }

    func testFetchVideosSuccess() {
        mockAPIManager.completeVideos = VideoResponse(videos: testData)
        sut.fetchAPIVideos()
        mockAPIManager.fetchSuccess()

        print("Setup: \(sut.videos)")
        XCTAssert(!sut.videos.isEmpty)
        XCTAssert(!sut.isLoading)
        XCTAssert(!sut.returnedError)
        XCTAssert(sut.errorMessage == nil)
    }

    func testFetchVideosFailure() {
        sut.fetchAPIVideos()
        mockAPIManager.fetchFail()
        XCTAssert(!sut.isLoading)
        XCTAssert(sut.returnedError)
        XCTAssert(sut.errorMessage != nil)
    }

}
