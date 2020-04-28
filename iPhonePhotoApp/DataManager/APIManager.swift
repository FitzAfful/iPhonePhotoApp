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

    init(manager: Session = Session.default) {
        super.init()
        self.manager = manager
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
    }

}
