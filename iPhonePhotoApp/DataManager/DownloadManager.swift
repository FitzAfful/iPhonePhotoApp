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
    func cancelDownload(video: VideoItem)
    func getCurrentDownload() -> VideoItem?
}

public class DownloadManager: NSObject, AVAssetDownloadDelegate, ObservableObject {
    static let shared: DownloadManager = DownloadManager()

    private var configuration: URLSessionConfiguration?
    private var downloadSession: AVAssetDownloadURLSession?
    private var dataManager: DataManagerProtocol?
    private var downloadIdentifier = "\(Bundle.main.bundleIdentifier!).background"
    private var currentVideo: VideoItem?
    private var downloadTask: AVAssetDownloadTask?
    @Published var percentage = 0.0
    @Published var errorMessage: String?

    init(dataManager: DataManagerProtocol = RealmManager.shared) {
        super.init()
        configuration = URLSessionConfiguration.background(withIdentifier: downloadIdentifier)
        downloadSession = AVAssetDownloadURLSession(configuration: configuration!, assetDownloadDelegate: self, delegateQueue: OperationQueue.main)
        self.dataManager = dataManager
    }

    func getCurrentDownload() -> VideoItem? {
        return currentVideo
    }

    func downloadVideo(video: VideoItem) {
        self.errorMessage = nil
        self.percentage = 0.0
        self.currentVideo = video

        let url = URL(string: video.videoLink)!
        let options = [
            AVURLAssetPreferPreciseDurationAndTimingKey: true,
            AVURLAssetReferenceRestrictionsKey: 0
            ] as [String: Any]
        let asset = AVURLAsset(url: url, options: options)
        downloadTask = downloadSession?.makeAssetDownloadTask(asset: asset, assetTitle: video.name, assetArtworkData: nil, options: nil)
        downloadTask?.resume()
    }

    func cancelDownload(video: VideoItem) {
        if let item = downloadTask {
            item.cancel()
            self.currentVideo = nil
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        errorMessage = error?.localizedDescription
        self.errorMessage = nil
        self.percentage = 0.0
        self.currentVideo = nil
    }

    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        var percentComplete = 0.0
        for value in loadedTimeRanges {
            let loadedTimeRange = value.timeRangeValue
            percentComplete += loadedTimeRange.duration.seconds / timeRangeExpectedToLoad.duration.seconds
        }
        percentComplete *= 100
        self.percentage = percentComplete
    }

    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        if assetDownloadTask.error != nil { return }
        if let video = currentVideo {
            try? self.dataManager?.updateVideo(video: video, downloadLocation: location.relativePath)
        }
        self.currentVideo = nil
        self.errorMessage = nil
    }

}
