//
//  DownloadManager.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import Alamofire
import AVKit
import Combine

protocol DownloadManagerProtocol {
    func downloadVideo(video: VideoItem)
    func getCurrentDownload() -> VideoItem?
}

public class DownloadManager: NSObject, AVAssetDownloadDelegate, ObservableObject {
    static let shared: DownloadManager = DownloadManager()

    private var configuration: URLSessionConfiguration?
    private var downloadSession: AVAssetDownloadURLSession?
    private var downloadIdentifier = "\(Bundle.main.bundleIdentifier!).background"
    private var currentVideo: VideoItem?
    @Published var percentage = 0.0

    override init() {
        super.init()
        configuration = URLSessionConfiguration.background(withIdentifier: downloadIdentifier)
        downloadSession = AVAssetDownloadURLSession(configuration: configuration!, assetDownloadDelegate: self, delegateQueue: OperationQueue.main)
    }

    func getCurrentDownload() -> VideoItem? {
        return currentVideo
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
        self.percentage = percentComplete
    }

    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        print("finish downloading: \(location)")
        UserDefaults.standard.set(location.relativePath, forKey: "testVideoPath")
        self.currentVideo = nil
    }

}
