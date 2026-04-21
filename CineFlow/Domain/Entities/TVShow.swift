//
//  TVShow.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - TV Show Entity
struct TVShow: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let genreIDs: [Int]
    let originalLanguage: String

    // Detail fields
    let genres: [Genre]?
    let numberOfSeasons: Int?
    let numberOfEpisodes: Int?
    let episodeRunTime: [Int]?
    let status: String?
    let tagline: String?
    let cast: [CastMember]?
    let videos: [MediaVideo]?
    let similar: [TVShow]?
    let networks: [Network]?

    var firstAirYear: String? {
        guard let date = firstAirDate, date.count >= 4 else { return nil }
        return String(date.prefix(4))
    }

    var episodeDurationFormatted: String? {
        guard let runtimes = episodeRunTime, let first = runtimes.first, first > 0 else { return nil }
        return "\(first)m / ep"
    }

    var officialTrailer: MediaVideo? {
        videos?.first { $0.isYouTubeTrailer } ?? videos?.first { $0.site == "YouTube" }
    }
}

// MARK: - Network
struct Network: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let logoPath: String?
}

// MARK: - Preview / Stub
extension TVShow {
    static let stub = TVShow(
        id: 1399,
        name: "Game of Thrones",
        overview: "Seven noble families fight for control of the mythical land of Westeros.",
        posterPath: "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg",
        backdropPath: "/suopoADq0k8YZr4dQXcU6pToj6s.jpg",
        firstAirDate: "2011-04-17",
        voteAverage: 8.4,
        voteCount: 22_025,
        popularity: 369.0,
        genreIDs: [10765, 18, 10759],
        originalLanguage: "en",
        genres: [Genre(id: 10765, name: "Sci-Fi & Fantasy"), Genre(id: 18, name: "Drama")],
        numberOfSeasons: 8,
        numberOfEpisodes: 73,
        episodeRunTime: [60],
        status: "Ended",
        tagline: "You win or you die.",
        cast: nil,
        videos: nil,
        similar: nil,
        networks: nil
    )
}
