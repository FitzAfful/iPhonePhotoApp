//
//  VideoDetailViewModel.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import Combine

protocol VideoDetailViewModelProtocol {
    func downloadVideo()
    func getCurrentVideo() -> VideoItem?
    func getVideo() -> VideoItem
}

class VideoDetailViewModel: ObservableObject {
    @Published var video: VideoItem?

    var downloadManager: DownloadManager!

    init(downloadManager: DownloadManager = DownloadManager.shared) {
        self.downloadManager = downloadManager
        _ = downloadManager.$percentage.sink { (value) in
            if self.getCurrentVideo() == self.video && self.getCurrentVideo() != nil {
                //update progressbar
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
