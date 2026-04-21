//
//  Movie.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Movie Entity
struct Movie: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let genreIDs: [Int]
    let originalLanguage: String
    let adult: Bool

    // Detail fields (populated on detail fetch)
    let genres: [Genre]?
    let runtime: Int?
    let tagline: String?
    let status: String?
    let budget: Int?
    let revenue: Int?
    let cast: [CastMember]?
    let videos: [MediaVideo]?
    let similar: [Movie]?

    var releaseYear: String? {
        guard let date = releaseDate, date.count >= 4 else { return nil }
        return String(date.prefix(4))
    }

    var runtimeFormatted: String? {
        guard let runtime, runtime > 0 else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours == 0 { return "\(minutes)m" }
        if minutes == 0 { return "\(hours)h" }
        return "\(hours)h \(minutes)m"
    }

    var officialTrailer: MediaVideo? {
        videos?.first { $0.isYouTubeTrailer } ?? videos?.first { $0.site == "YouTube" }
    }
}

// MARK: - Preview / Stub
extension Movie {
    static let stub = Movie(
        id: 550,
        title: "Fight Club",
        overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
        posterPath: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
        backdropPath: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
        releaseDate: "1999-10-15",
        voteAverage: 8.4,
        voteCount: 26_280,
        popularity: 61.41,
        genreIDs: [18, 53],
        originalLanguage: "en",
        adult: false,
        genres: [Genre(id: 18, name: "Drama"), Genre(id: 53, name: "Thriller")],
        runtime: 139,
        tagline: "Mischief. Mayhem. Soap.",
        status: "Released",
        budget: 63_000_000,
        revenue: 101_209_702,
        cast: nil,
        videos: nil,
        similar: nil
    )
}
