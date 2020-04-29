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
    var realm: Realm? = try! Realm()

    func fetchVideos(completionHandler: @escaping FetchVideosCompletionHandler) throws {
        guard let myRealm = realm else { throw RuntimeError.NoRealmSet }
        let videos = myRealm.objects(VideoItem.self)
        let response = VideoResponse(videos: videos.compactMap({ $0 }))
        completionHandler(.success(response))
    }

    func saveVideos(videos: [VideoItem]) throws {
        guard let myRealm = realm else { throw  RuntimeError.NoRealmSet }
        try? myRealm.write {
            myRealm.add(videos, update: .modified)
        }
    }

    func updateVideo(video: VideoItem, downloadLocation: String) throws {
        guard let myRealm = realm else { throw  RuntimeError.NoRealmSet }
        try? myRealm.write {
            let downloadedVideo = DownloadedVideo(id: video.id, downloadLocation: downloadLocation)
            myRealm.add(downloadedVideo, update: .modified)
        }
    }

    func getDownloadedLocation(video: VideoItem) throws -> String? {
        guard let myRealm = realm else { throw  RuntimeError.NoRealmSet }
        if let dlVideo = myRealm.objects(DownloadedVideo.self).filter({ (vid) -> Bool in
            return vid.id == video.id
        }).first {
            return dlVideo.downloadLocation
        }
        return nil
    }

    func clearVideos() throws {
        guard let myRealm = realm else { throw  RuntimeError.NoRealmSet }
        let results = myRealm.objects(VideoItem.self)
        try? myRealm.write {
            myRealm.delete(results)
        }
    }
}
