//
//  VideoDetailViewModel.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol VideoDetailViewModelProtocol {
    func downloadVideo()
    func getCurrentVideo() -> VideoItem?
    func getVideo() -> VideoItem
}

class VideoDetailViewModel: ObservableObject {
    @Published var video: VideoItem?
    @Published var isDownloading: Bool = false
    @Published var progress: CGFloat = 0.0

    var downloadManager: DownloadManager!

    init(downloadManager: DownloadManager = DownloadManager.shared) {
        self.downloadManager = downloadManager
        _ = downloadManager.$percentage.sink { (value) in
            if self.getCurrentVideo() == self.video && self.getCurrentVideo() != nil {
                self.isDownloading = true
                self.progress = CGFloat(value)
                print("\(self.video!.name) - \(value)%")
            }
        }
    }
}

extension VideoDetailViewModel: VideoDetailViewModelProtocol {
    func downloadVideo() {
        guard let myVideo = self.video else { return }
        downloadManager.downloadVideo(video: myVideo)
    }

    func cancelDownload() {
        guard let myVideo = self.video else { return }
        downloadManager.cancelDownload(video: myVideo)
        isDownloading = false
    }

    func getCurrentVideo() -> VideoItem? {
        if let currentVideo = downloadManager.getCurrentDownload() {
            return currentVideo
        }
        return nil
    }

    func getVideo() -> VideoItem {
        return video!
    }

}
