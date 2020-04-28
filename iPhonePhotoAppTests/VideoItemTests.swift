//
//  VideoItemTests.swift
//  iPhonePhotoAppTests
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import XCTest
@testable import Alamofire
@testable import Mocker
@testable import iPhonePhotoApp

class VideoItemTests: XCTestCase {

    var bundle: Bundle!

    override func setUpWithError() throws {
        bundle = Bundle(for: VideoItemTests.self)
    }

    func testSingleVideoJSONMapping() throws {
        guard let url = bundle.url(forResource: "videoItem", withExtension: "json") else {
            XCTFail("Missing file: videoItem.json")
            return
        }

        let json = try Data(contentsOf: url)
        let videoItem = try! JSONDecoder().decode(VideoItem.self, from: json)

        XCTAssertEqual(videoItem.name, "How To Hold Your iPhone When Taking Photos")
        XCTAssertEqual(videoItem.id, 950)
    }

    func testVideoResponseJSONMapping() throws {
        guard let url = bundle.url(forResource: "videoResponse", withExtension: "json") else {
            XCTFail("Missing file: videoResponse.json")
            return
        }

        let json = try Data(contentsOf: url)
        let data = try! JSONDecoder().decode(VideoResponse.self, from: json)

        XCTAssertEqual(data.videos[1].name, "3 Quick Ways To Open The iPhone Camera App")
        XCTAssertEqual(data.videos[2].videoLink, "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


}
