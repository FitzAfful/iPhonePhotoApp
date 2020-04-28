//
//  APIManager.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import Alamofire
import AVKit

typealias FetchVideosCompletionHandler = (_ videoResponse: Result<VideoResponse, AFError>) -> Void

protocol DataManagerProtocol {
    func fetchVideos(completionHandler: @escaping FetchVideosCompletionHandler) throws
    func saveVideos(videos: [VideoItem]) throws
    func downloadVideo(video: VideoItem)
    func getCurrentDownload() -> VideoItem?
}

public class APIManager: NSObject, DataManagerProtocol, AVAssetDownloadDelegate {
    static let shared: DataManagerProtocol = APIManager()
    private var manager: Session = Session.default

    private var configuration: URLSessionConfiguration?
    private var downloadSession: AVAssetDownloadURLSession?
    private var downloadIdentifier = "\(Bundle.main.bundleIdentifier!).background"

    private var currentVideo: VideoItem?

    init(manager: Session = Session.default) {
        super.init()
        self.manager = manager
        configuration = URLSessionConfiguration.background(withIdentifier: downloadIdentifier)
        downloadSession = AVAssetDownloadURLSession(configuration: configuration!, assetDownloadDelegate: self, delegateQueue: OperationQueue.main)
    }

    func fetchVideos(completionHandler: @escaping FetchVideosCompletionHandler) {
        manager.request(APIRouter.getVideos).responseDecodable { (response) in
            completionHandler(response.result)
        }
    }

    func saveVideos(videos: [VideoItem]) {

    }

    func getCurrentDownload() -> VideoItem? {
        return nil
    }

    func downloadVideo(video: VideoItem) {
        let url = URL(string: video.videoLink)!
        print(url)
        let options = [
            AVURLAssetPreferPreciseDurationAndTimingKey: true,
            AVURLAssetReferenceRestrictionsKey: 0
            ] as [String: Any]
        let asset = AVURLAsset(url: url, options: options)
        let downloadTask = downloadSession?.makeAssetDownloadTask(asset: asset, assetTitle: video.name, assetArtworkData: nil, options: nil)
        downloadTask?.resume()
        self.currentVideo = video
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("Completed with error: \(error)")
        self.currentVideo = nil
    }

    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        print("didload")
        var percentComplete = 0.0
        for value in loadedTimeRanges {
            let loadedTimeRange = value.timeRangeValue
            percentComplete += loadedTimeRange.duration.seconds / timeRangeExpectedToLoad.duration.seconds
        }
        percentComplete *= 100
        debugPrint("Progress \( assetDownloadTask) \(percentComplete)")
        let params = ["percent": percentComplete]
    }

    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        print("finish downloading: \(location)")
        UserDefaults.standard.set(location.relativePath, forKey: "testVideoPath")
        self.currentVideo = nil
    }

}
