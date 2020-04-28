//
//  ContentView.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import SwiftUI

struct VideoListView: View {
    @ObservedObject var viewModel = VideoListViewModel()

    init() {
        UITableView.appearance().tableFooterView = UIView()
    }

    var body: some View {
        return NavigationView {
            List(viewModel.videos) { video in
                VideoCell(video: video)
            }.onPull(perform: {
                self.viewModel.fetchVideos()
            }, isLoading: viewModel.isLoading).onAppear {
                self.viewModel.fetchVideos()
            }.alert(isPresented: $viewModel.returnedError) { () -> Alert in
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage!), dismissButton: .default(Text("Okay"), action: {
                    self.viewModel.returnedError = false
                }))
            }.navigationBarTitle(Text("Videos"))
        }
    }
}

struct VideoCell: View {
    var video: VideoItem
    @ObservedObject var image: FetchImage

    init(video: VideoItem) {
        self.video = video
        print(video)
        print(video.thumbnail)
        let url = URL(string: video.thumbnail)!
        self.image = FetchImage(url: url)
    }

    var body: some View {
        let viewModel = VideoDetailViewModel()
        viewModel.video = self.video
        return NavigationLink(destination: VideoDetailView(viewModel: viewModel, image: image).environmentObject(PlayerState())) {
            image.view?.resizable()
            .frame(width: 50.0, height: 50.0).cornerRadius(5.0)
            VStack(alignment: .leading) {
                Text(video.name)
            }.onAppear(perform: image.fetch).onDisappear(perform: image.cancel)
        }
    }
}
