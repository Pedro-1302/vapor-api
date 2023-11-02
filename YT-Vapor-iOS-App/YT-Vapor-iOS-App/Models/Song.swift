//
//  Song.swift
//  YT-Vapor-iOS-App
//
//  Created by Pedro Franco on 13/10/23.
//

import Foundation

struct Song: Identifiable, Codable {
    let id: UUID?
    var title: String
}
