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
    func getDownloadedVideoLocation() -> String?
}

class VideoDetailViewModel: ObservableObject {
    @Published var video: VideoItem?
    @Published var isDownloading: Bool = false
    @Published var progress: CGFloat = 0.0
    @Published var downloadErrorMessage: String?
    @Published var downloadReturnedError: Bool = false
    @Published var finishedDownloading: Bool = false

    var downloadManager: DownloadManager?
    var dataManager: DataManagerProtocol? = RealmManager.shared
    private var cancellable = Set<AnyCancellable>()

    init(downloadManager: DownloadManager = DownloadManager.shared) {
        self.isDownloading = false
        self.finishedDownloading = false

        self.downloadManager = downloadManager
        downloadManager.$percentage.sink { (value) in
            if self.getCurrentVideo() == self.video && self.getCurrentVideo() != nil {
                self.isDownloading = true
                self.progress = CGFloat(value)
                if self.progress == 100.0 {
                    self.finishedDownloading = true
                }
            }
        }.store(in: &cancellable)

        downloadManager.$errorMessage.sink { (value) in
            self.downloadErrorMessage = value
            self.downloadReturnedError = value != nil
            if value != nil {
                self.isDownloading = false
            }
        }.store(in: &cancellable)
    }
}

extension VideoDetailViewModel: VideoDetailViewModelProtocol {
    func downloadVideo() {
        guard let myVideo = self.video else { return }
        downloadManager!.downloadVideo(video: myVideo)
        isDownloading = true
    }

    func cancelDownload() {
        guard let myVideo = self.video else { return }
        downloadManager!.cancelDownload(video: myVideo)
        isDownloading = false
    }

    func getCurrentVideo() -> VideoItem? {
        if let currentVideo = downloadManager!.getCurrentDownload() {
            return currentVideo
        }
        return nil
    }

    func getVideo() -> VideoItem {
        return video!
    }

    func getDownloadedVideoLocation() -> String? {
        return try? dataManager!.getDownloadedLocation(video: self.getVideo())
    }

}
