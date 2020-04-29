//
//  MockAPIManager.swift
//  iPhonePhotoAppTests
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
@testable import iPhonePhotoApp
@testable import Alamofire

class MockApiManager: DataManagerProtocol {

    var completeVideos: VideoResponse = VideoResponse(videos: [VideoItem]())
    var isFetchVideosCalled = false
    var completeClosure: FetchVideosCompletionHandler!

    func fetchVideos(completionHandler: @escaping FetchVideosCompletionHandler) throws {
        isFetchVideosCalled = true
        completeClosure = completionHandler
    }

    func fetchSuccess() {
        completeClosure(Result(value: completeVideos, error: nil))
    }

    func fetchFail() {
        let result = Result<VideoResponse, AFError>.failure(AFError.explicitlyCancelled)
        completeClosure(result)
    }

    func saveVideos(videos: [VideoItem]) throws {}

    func downloadVideo(video: VideoItem) {}

    func getCurrentDownload() -> VideoItem? { return nil }

    func updateVideo(video: VideoItem, downloadLocation: String) throws {}

    func getDownloadedLocation(video: VideoItem) throws -> String? { return nil }

}
