//
//  RealmManager.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import RealmSwift

enum RuntimeError: Error {
    case NoRealmSet
    case FetchFailed
}

public class RealmManager: NSObject, DataManagerProtocol {
    static let shared: DataManagerProtocol = RealmManager()
    private var realm: Realm?

    override init() {
        realm = try? Realm()
    }

    func fetchVideos(completionHandler: @escaping FetchVideosCompletionHandler) throws {
        guard let myRealm = realm else { throw RuntimeError.NoRealmSet }
        let videos = myRealm.objects(VideoItem.self)
        let response = VideoResponse(videos: videos.compactMap({ $0 }))
        completionHandler(.success(response))
    }

    func saveVideos(videos: [VideoItem]) throws {
        guard let myRealm = realm else { throw  RuntimeError.NoRealmSet }
        try? myRealm.write {
            myRealm.add(videos, update: .all)
        }
    }

    func downloadVideo(video: VideoItem) {
    }

    func getCurrentDownload() -> VideoItem? {
        return nil
    }
}
