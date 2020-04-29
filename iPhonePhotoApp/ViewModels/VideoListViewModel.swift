//
//  VideoListViewModel.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import Combine

protocol VideoListViewModelProtocol {
    func fetchVideos()
    func fetchAPIVideos()
}

class VideoListViewModel: ObservableObject {
    @Published var videos = [VideoItem]()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var returnedError: Bool = false

    var dataManager: DataManagerProtocol
    var realmManager: RealmManager = RealmManager.shared as! RealmManager

    init(dataManager: DataManagerProtocol = APIManager.shared) {
        self.dataManager = dataManager
        fetchVideos()
    }
}

extension VideoListViewModel: VideoListViewModelProtocol {
    func fetchVideos() {
        isLoading = true
        var delayTimer = 0.0
        try? realmManager.fetchVideos { (result) in
            if let realmVideos = try? result.get().videos {
                self.videos = realmVideos
                if !self.videos.isEmpty {
                    delayTimer = 3.0
                }
            }
        }

        UtilityHelper().delay(delayTimer) {
            self.fetchAPIVideos()
        }
    }

    func fetchAPIVideos() {
        try? self.dataManager.fetchVideos { (result) in
            switch result {
            case .success(let response):
                self.videos = response.videos
                try? self.realmManager.saveVideos(videos: self.videos)
                self.isLoading = false
                self.errorMessage = nil
                self.returnedError = false
            case .failure:
                self.isLoading = false
                self.returnedError = true
                self.errorMessage = "Please check your internet connection and try again."
            }
        }
    }
}
