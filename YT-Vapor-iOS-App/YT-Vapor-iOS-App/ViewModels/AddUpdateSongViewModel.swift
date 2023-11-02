//
//  AddUpdateSongViewModel.swift
//  YT-Vapor-iOS-App
//
//  Created by Pedro Franco on 15/10/23.
//

import SwiftUI

final class AddUpdateSongViewModel: ObservableObject {
    @Published var songTitle = ""
    
    var songID: UUID?
    var isUpdating: Bool {
        songID != nil
    }
    
    var buttonTitle: String {
        songID != nil ? "Update Song" : "Add Song"
    }
    
    init() { }
    
    init(currentSong: Song) {
        self.songTitle = currentSong.title
        self.songID = currentSong.id    
    }
    
    func addSong() async throws {
        let urlString = Constants.baseURL + Endpoints
            .songs
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badUrl
        }
        
        let song = Song(id: nil, title: songTitle)
        
        try await HttpClient.shared.sendData(to: url,
                                             object: song,
                                             httpMehotd: HttpMethods.POST.rawValue)
    }
    
    func addUpdateAction(completion: @escaping () -> Void) {
        Task {
            do {
                if isUpdating {
                    try await updateSong()
                } else {
                    try await addSong()
                }
            } catch {
                print("Error: \(error)")
            }
            completion()
        }
    }
    
    func updateSong() async throws {
        let urlString = Constants.baseURL + Endpoints
            .songs
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badUrl
        }
        
        let songToUpdate = Song(id: songID, title: songTitle)
        
        try await HttpClient.shared.sendData(to: url, object: songToUpdate, httpMehotd: HttpMethods.PUT.rawValue)
    }
}
