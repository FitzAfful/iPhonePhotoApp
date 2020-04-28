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

    var dataManager: DataManagerProtocol

    init(dataManager: DataManagerProtocol = APIManager.shared) {
        self.dataManager = dataManager
    }
}

extension VideoDetailViewModel: VideoDetailViewModelProtocol {
    func downloadVideo() {
        guard let myVideo = self.video else { return }
        dataManager.downloadVideo(video: myVideo)
    }

    func getCurrentVideo() -> VideoItem? {
        if let currentVideo = dataManager.getCurrentDownload() {
            return currentVideo
        }
        return nil
    }

    func getVideo() -> VideoItem {
        return video!
    }
}
