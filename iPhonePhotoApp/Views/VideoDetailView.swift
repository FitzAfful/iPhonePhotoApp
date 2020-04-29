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
            ProgressBar(progress: $viewModel.progress)
                .frame(width: 300, height: 4.0).accessibility(identifier: "progressBar").isHidden(!self.viewModel.isDownloading)
            ZStack {
                image.view?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200).border(Color.clear).cornerRadius(5.0)
                    .clipped()

                Button(action: {
                    if let link = self.viewModel.getDownloadedVideoLocation() {
                        print("Link: \(link)")
                        let baseUrl = URL(fileURLWithPath: NSHomeDirectory())
                        self.videoURL = baseUrl.appendingPathComponent(link)
                    } else {
                        print("Link 00: \(self.viewModel.getVideo().videoLink)")
                        self.videoURL = URL(string: self.viewModel.getVideo().videoLink)!
                    }
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
                if self.viewModel.isDownloading {
                    self.viewModel.cancelDownload()
                } else {
                    if self.viewModel.getCurrentVideo() != nil {
                        self.showingAlert = true
                    } else {
                        self.viewModel.downloadVideo()
                    }
                }
            }) {
                if viewModel.isDownloading {
                    Text("Cancel Download")
                } else {
                    Text("Download video")
                    Image(systemName: "square.and.arrow.down")
                }
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Video is being downloaded. Please hold on."), dismissButton: .default(Text("Okay")))
            }.alert(isPresented: $viewModel.downloadReturnedError) { () -> Alert in
                var videoName = ""
                if let vid = self.viewModel.getCurrentVideo() {
                    videoName = vid.name + ": "
                }
                return Alert(title: Text("Download Error"), message: Text("\(videoName) " + self.viewModel.downloadErrorMessage!), dismissButton: .default(Text("Okay"), action: {
                    self.viewModel.downloadReturnedError = false
                }))
            }
        )
    }
}
