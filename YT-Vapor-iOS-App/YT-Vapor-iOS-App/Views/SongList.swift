//
//  SongList.swift
//  YT-Vapor-iOS-App
//
//  Created by Pedro Franco on 13/10/23.
//

import SwiftUI

struct SongList: View {
    
    @StateObject var viewModel = SongListViewModel()
    
    @State var modal: ModalType? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.songs) {
                    song in
                    Button {
                        modal = .update(song)
                    } label: {
                        Text(song.title)
                            .font(.title3)
                            .foregroundStyle(Color(.label))
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
            .navigationTitle(Text("Songs"))
            .toolbar {
                Button {
                    modal = .add
                } label: {
                    Label("Add Song", systemImage: "plus")
                }
            }
        }
        .sheet(item: $modal, onDismiss: {
            Task {
                do {
                    try await viewModel.fetchSongs()
                } catch {
                    print("Error: \(error)")
                }
            }
        }) { modal in
            switch modal {
                case .add:
                    AddUpdateSong(viewModel: AddUpdateSongViewModel())
                case .update(let song):
                    AddUpdateSong(viewModel: AddUpdateSongViewModel(currentSong: song))
            }
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchSongs()
                } catch {
                    print("Error \(error)")
                }
            }
        }
    }
}

#Preview {
    SongList()
}
