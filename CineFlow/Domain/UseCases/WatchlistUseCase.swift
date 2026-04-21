//
//  WatchlistUseCase.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation
import SwiftData

// MARK: - Watchlist Use Case Protocol
@MainActor
protocol WatchlistUseCaseProtocol: AnyObject {
    func add(movie: Movie, context: ModelContext)
    func add(tvShow: TVShow, context: ModelContext)
    func remove(id: Int, mediaType: MediaType, context: ModelContext)
    func isFavorite(id: Int, mediaType: MediaType, context: ModelContext) -> Bool
    func toggle(movie: Movie, context: ModelContext)
    func toggle(tvShow: TVShow, context: ModelContext)
}

// MARK: - Watchlist Use Case
@MainActor
final class WatchlistUseCase: WatchlistUseCaseProtocol {

    func add(movie: Movie, context: ModelContext) {
        guard !isFavorite(id: movie.id, mediaType: .movie, context: context) else { return }
        let item = WatchlistItem(
            id: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            voteAverage: movie.voteAverage,
            releaseYear: movie.releaseYear,
            mediaType: .movie
        )
        context.insert(item)
    }

    func add(tvShow: TVShow, context: ModelContext) {
        guard !isFavorite(id: tvShow.id, mediaType: .tvShow, context: context) else { return }
        let item = WatchlistItem(
            id: tvShow.id,
            title: tvShow.name,
            posterPath: tvShow.posterPath,
            backdropPath: tvShow.backdropPath,
            voteAverage: tvShow.voteAverage,
            releaseYear: tvShow.firstAirYear,
            mediaType: .tvShow
        )
        context.insert(item)
    }

    func remove(id: Int, mediaType: MediaType, context: ModelContext) {
        let descriptor = FetchDescriptor<WatchlistItem>(
            predicate: #Predicate { $0.mediaId == id && $0.rawMediaType == mediaType.rawValue }
        )
        guard let items = try? context.fetch(descriptor) else { return }
        items.forEach { context.delete($0) }
    }

    func isFavorite(id: Int, mediaType: MediaType, context: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<WatchlistItem>(
            predicate: #Predicate { $0.mediaId == id && $0.rawMediaType == mediaType.rawValue }
        )
        let count = (try? context.fetchCount(descriptor)) ?? 0
        return count > 0
    }

    func toggle(movie: Movie, context: ModelContext) {
        if isFavorite(id: movie.id, mediaType: .movie, context: context) {
            remove(id: movie.id, mediaType: .movie, context: context)
        } else {
            add(movie: movie, context: context)
        }
    }

    func toggle(tvShow: TVShow, context: ModelContext) {
        if isFavorite(id: tvShow.id, mediaType: .tvShow, context: context) {
            remove(id: tvShow.id, mediaType: .tvShow, context: context)
        } else {
            add(tvShow: tvShow, context: context)
        }
    }
}
