//
//  SongListViewModel.swift
//  YT-Vapor-iOS-App
//
//  Created by Pedro Franco on 13/10/23.
//

import SwiftUI

class SongListViewModel: ObservableObject {
    @Published var songs = [Song]()
    
    func fetchSongs() async throws {
        let urlString = Constants.baseURL + Endpoints
            .songs
        
        // Checa se a URL existe
        guard let url = URL(string: urlString) else {
            throw HttpError.badUrl
        }
        
        let songResponse: [Song] = try await HttpClient.shared.fetch(url: url)
        
        DispatchQueue.main.async {
            self.songs = songResponse
        }
    }
    
    // Recebe os indíces de uma coleção que eu pasar
    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            // Verifica se o id que eu quero deletar existe dentro dos outros que tenho cadastrado
            guard let songID = songs[i].id else {
                return
            }
            
            // Verifica se a url + id existem
            guard let url = URL(string: Constants.baseURL + Endpoints.songs + "/\(songID)") else {
                return
            }
            
            Task {
                do {
                    try await HttpClient.shared.delete(at: songID, url: url)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        
        songs.remove(atOffsets: offsets)

    }
}

