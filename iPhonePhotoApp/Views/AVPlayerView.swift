//
//  AVPlayerView.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import AVKit
import SwiftUI

struct AVPlayerView: UIViewControllerRepresentable {

    @EnvironmentObject var playerState: PlayerState
    @Binding var videoURL: URL?

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        playerController.modalPresentationStyle = .overFullScreen
        playerController.player = playerState.player(for: videoURL!)
        playerController.player?.play()
        return playerController
    }
}
