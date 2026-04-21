//
//  TVShowDTO.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - TV Show DTO
struct TVShowDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let genreIds: [Int]?
    let originalLanguage: String

    // Detail only
    let genres: [GenreDTO]?
    let numberOfSeasons: Int?
    let numberOfEpisodes: Int?
    let episodeRunTime: [Int]?
    let status: String?
    let tagline: String?
    let credits: CreditsDTO?
    let videos: VideoResponseDTO?
    let similar: PagedResponseDTO<TVShowDTO>?
    let networks: [NetworkDTO]?

    func toDomain() -> TVShow {
        TVShow(
            id: id,
            name: name,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            firstAirDate: firstAirDate,
            voteAverage: voteAverage,
            voteCount: voteCount,
            popularity: popularity,
            genreIDs: genreIds ?? [],
            originalLanguage: originalLanguage,
            genres: genres?.map { $0.toDomain() },
            numberOfSeasons: numberOfSeasons,
            numberOfEpisodes: numberOfEpisodes,
            episodeRunTime: episodeRunTime,
            status: status,
            tagline: tagline,
            cast: credits?.cast?.prefix(15).map { $0.toDomain() },
            videos: videos?.results?.compactMap { $0.toDomain() },
            similar: similar?.results.prefix(10).map { $0.toDomain() },
            networks: networks?.map { $0.toDomain() }
        )
    }
}

// MARK: - Network DTO
struct NetworkDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let logoPath: String?

    func toDomain() -> Network {
        Network(id: id, name: name, logoPath: logoPath)
    }
}
