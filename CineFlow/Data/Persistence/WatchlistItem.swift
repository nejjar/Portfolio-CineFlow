//
//  WatchlistItem.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation
import SwiftData

// MARK: - SwiftData Watchlist Model
@Model
final class WatchlistItem {
    @Attribute(.unique) var uniqueKey: String // "\(mediaType.rawValue)-\(id)"
    var mediaId: Int
    var title: String
    var posterPath: String?
    var backdropPath: String?
    var voteAverage: Double
    var releaseYear: String?
    var rawMediaType: String
    var addedAt: Date

    var mediaType: MediaType {
        MediaType(rawValue: rawMediaType) ?? .movie
    }

    init(
        id: Int,
        title: String,
        posterPath: String?,
        backdropPath: String?,
        voteAverage: Double,
        releaseYear: String?,
        mediaType: MediaType
    ) {
        self.uniqueKey = "\(mediaType.rawValue)-\(id)"
        self.mediaId = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.voteAverage = voteAverage
        self.releaseYear = releaseYear
        self.rawMediaType = mediaType.rawValue
        self.addedAt = Date()
    }
}
