//
//  VideoItem.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import RealmSwift

class VideoItem: Object, Codable, Identifiable {
    @objc var id: Int = 0
    @objc var name: String = ""
    @objc var thumbnail: String = ""
    @objc var details: String = ""
    @objc var videoLink: String = ""

    convenience init(id: Int, name: String, thumbnail: String, details: String, videoLink: String) {
        self.init()
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.details = details
        self.videoLink = videoLink
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case thumbnail
        case details = "description"
        case videoLink = "video_link"
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}

struct VideoResponse: Codable, Equatable {
    var videos: [VideoItem]

    static public func == (lhs: VideoResponse, rhs: VideoResponse) -> Bool {
        return (lhs.videos[0].id == rhs.videos[0].id && lhs.videos[0].name == rhs.videos[0].name)
    }
}
