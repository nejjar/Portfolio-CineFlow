//
//  MediaItem.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Media Type
enum MediaType: String, Codable, Hashable {
    case movie
    case tvShow = "tv"
    case person
}

// MARK: - Genre
struct Genre: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}

// MARK: - Cast Member
struct CastMember: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    let order: Int
}

// MARK: - Production Company
struct ProductionCompany: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let logoPath: String?
}

// MARK: - Video (Trailer)
struct MediaVideo: Identifiable, Codable, Hashable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    let official: Bool

    var isYouTubeTrailer: Bool {
        site == "YouTube" && type == "Trailer"
    }

    var youTubeThumbnailURL: URL? {
        URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
    }
}
