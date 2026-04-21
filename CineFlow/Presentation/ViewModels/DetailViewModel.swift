//
//  DetailViewModel.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation
import SwiftData

// MARK: - Movie Detail View Model
@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isInWatchlist = false

    private let fetchDetailUseCase: FetchDetailUseCaseProtocol
    private let watchlistUseCase: WatchlistUseCaseProtocol

    init(
        movie: Movie,
        fetchDetailUseCase: FetchDetailUseCaseProtocol,
        watchlistUseCase: WatchlistUseCaseProtocol
    ) {
        self.movie = movie
        self.fetchDetailUseCase = fetchDetailUseCase
        self.watchlistUseCase = watchlistUseCase
    }

    func loadDetails(context: ModelContext) async {
        isLoading = true
        errorMessage = nil
        isInWatchlist = watchlistUseCase.isFavorite(id: movie.id, mediaType: .movie, context: context)
        do {
            movie = try await fetchDetailUseCase.executeMovie(id: movie.id)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }

    func toggleWatchlist(context: ModelContext) {
        watchlistUseCase.toggle(movie: movie, context: context)
        isInWatchlist = watchlistUseCase.isFavorite(id: movie.id, mediaType: .movie, context: context)
    }
}

// MARK: - TV Show Detail View Model
@MainActor
final class TVShowDetailViewModel: ObservableObject {
    @Published var tvShow: TVShow
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isInWatchlist = false

    private let fetchDetailUseCase: FetchDetailUseCaseProtocol
    private let watchlistUseCase: WatchlistUseCaseProtocol

    init(
        tvShow: TVShow,
        fetchDetailUseCase: FetchDetailUseCaseProtocol,
        watchlistUseCase: WatchlistUseCaseProtocol
    ) {
        self.tvShow = tvShow
        self.fetchDetailUseCase = fetchDetailUseCase
        self.watchlistUseCase = watchlistUseCase
    }

    func loadDetails(context: ModelContext) async {
        isLoading = true
        errorMessage = nil
        isInWatchlist = watchlistUseCase.isFavorite(id: tvShow.id, mediaType: .tvShow, context: context)
        do {
            tvShow = try await fetchDetailUseCase.executeTVShow(id: tvShow.id)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }

    func toggleWatchlist(context: ModelContext) {
        watchlistUseCase.toggle(tvShow: tvShow, context: context)
        isInWatchlist = watchlistUseCase.isFavorite(id: tvShow.id, mediaType: .tvShow, context: context)
    }
}
