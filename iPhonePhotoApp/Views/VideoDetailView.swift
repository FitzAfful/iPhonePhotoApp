//
//  DetailView.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import SwiftUI

struct VideoDetailView: View {
    @ObservedObject var viewModel = VideoDetailViewModel()
    @ObservedObject var image: FetchImage

    @EnvironmentObject var playerState: PlayerState
    @State private var videoURL: URL?
    @State private var showVideoPlayer = false
    @State private var showingAlert = false

    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.gray)
                        .opacity(0.3)
                        .frame(width: 345.0, height: 8.0)
                    Rectangle()
                        .foregroundColor(Color.blue)
                        .frame(width: 200.0, height: 8.0)
                }
                Button(action: {
                    if self.viewModel.getCurrentVideo() != nil {
                        self.showingAlert = true
                    } else {
                        self.viewModel.downloadVideo()
                    }
                }) {
                    Text("Cancel Download")
                }
            }
            .cornerRadius(4.0)
            ZStack {
                image.view?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200).border(Color.clear).cornerRadius(5.0)
                    .clipped()

                Button(action: {
                    self.videoURL = URL(string: self.viewModel.getVideo().videoLink)!
                    self.showVideoPlayer = true
                }) {
                    Image("play")
                        .aspectRatio(contentMode: .fit).colorMultiply(.white)
                }.sheet(isPresented: $showVideoPlayer, onDismiss: { self.playerState.currentPlayer?.pause()
                }) {
                    AVPlayerView(videoURL: self.$videoURL)
                        .edgesIgnoringSafeArea(.all)
                        .environmentObject(self.playerState)
                }.accentColor(.white)
            }
            Text(viewModel.getVideo().name).font(.system(size: 27, weight: .semibold, design: .default)).multilineTextAlignment(.center).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            Text(viewModel.getVideo().details).accessibility(identifier: "detailsLabel")
            Spacer()
        }.onAppear(perform: image.fetch).onDisappear(perform: image.cancel).padding(10.0).navigationBarTitle("", displayMode: .inline).navigationBarItems(trailing:
            Button(action: {
                if self.viewModel.getCurrentVideo() != nil {
                    self.showingAlert = true
                } else {
                    self.viewModel.downloadVideo()
                }
            }) {
                Text("Download video")
                Image(systemName: "square.and.arrow.down")
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Video is being downloaded. Please hold on."), dismissButton: .default(Text("Okay")))
            }
        )
    }
}

