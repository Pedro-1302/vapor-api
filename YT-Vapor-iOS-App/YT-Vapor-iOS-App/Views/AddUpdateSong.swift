//
//  AddUpdateSong.swift
//  YT-Vapor-iOS-App
//
//  Created by Pedro Franco on 15/10/23.
//

import SwiftUI

struct AddUpdateSong: View {
    
    @ObservedObject var viewModel: AddUpdateSongViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("song title", text: $viewModel.songTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button {
                viewModel.addUpdateAction {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text(viewModel.buttonTitle)
            }
        }
    }
}

#Preview {
    AddUpdateSong(viewModel: AddUpdateSongViewModel())
}
