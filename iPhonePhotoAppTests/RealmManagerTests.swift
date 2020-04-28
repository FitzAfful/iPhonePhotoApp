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
        let testData = [
            VideoItem(id: 950, name: "How To Hold Your iPhone When Taking Photos", thumbnail: "https://i.picsum.photos/id/477/2000/2000.jpg", details: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum", videoLink: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"),
            VideoItem(id: 7991, name: "3 Quick Ways To Open The iPhone Camera App", thumbnail: "https://i.picsum.photos/id/477/2000/2000.jpg", details: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum", videoLink: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")]

        do {
            try sut.saveVideos(videos: testData)

            try sut.fetchVideos { (result) in
                switch result {
                case .success(let response):
                    XCTAssertEqual(response.videos.count, 2)
                    XCTAssertEqual(response.videos[0], testData[0])
                case .failure:
                    XCTFail()
                }
            }
        } catch RuntimeError.NoRealmSet {
            XCTAssert(false, "No realm DB was set")
        } catch  {
            XCTAssert(false, "Unexpected Error: \(error)")
        }

    }

}
