//
//  MovieDTO.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Movie DTO
struct MovieDTO: Decodable, Sendable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let genreIds: [Int]?
    let originalLanguage: String
    let adult: Bool?

    // Detail only
    let genres: [GenreDTO]?
    let runtime: Int?
    let tagline: String?
    let status: String?
    let budget: Int?
    let revenue: Int?
    let credits: CreditsDTO?
    let videos: VideoResponseDTO?
    let similar: PagedResponseDTO<MovieDTO>?

    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            voteCount: voteCount,
            popularity: popularity,
            genreIDs: genreIds ?? [],
            originalLanguage: originalLanguage,
            adult: adult ?? false,
            genres: genres?.map { $0.toDomain() },
            runtime: runtime,
            tagline: tagline,
            status: status,
            budget: budget,
            revenue: revenue,
            cast: credits?.cast?.prefix(15).map { $0.toDomain() },
            videos: videos?.results?.compactMap { $0.toDomain() },
            similar: similar?.results.prefix(10).map { $0.toDomain() }
        )
    }
}

// MARK: - Genre DTO
struct GenreDTO: Decodable, Sendable {
    let id: Int
    let name: String

    func toDomain() -> Genre { Genre(id: id, name: name) }
}

// MARK: - Credits DTO
struct CreditsDTO: Decodable, Sendable {
    let cast: [CastMemberDTO]?
}

struct CastMemberDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    let order: Int

    func toDomain() -> CastMember {
        CastMember(id: id, name: name, character: character, profilePath: profilePath, order: order)
    }
}

// MARK: - Video DTO
struct VideoResponseDTO: Decodable, Sendable {
    let results: [VideoDTO]?
}

struct VideoDTO: Decodable, Sendable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    let official: Bool?

    func toDomain() -> MediaVideo {
        MediaVideo(id: id, key: key, name: name, site: site, type: type, official: official ?? false)
    }
}
