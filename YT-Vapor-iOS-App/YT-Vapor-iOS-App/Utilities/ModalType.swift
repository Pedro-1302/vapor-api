//
//  ModalType.swift
//  YT-Vapor-iOS-App
//
//  Created by Pedro Franco on 15/10/23.
//

import Foundation

enum ModalType: Identifiable {
    var id : String {
        switch self {
            case .add: return "add"
            case .update: return "update"
        }
    }
    
    case add
    case update(Song)
}
