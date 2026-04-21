//
//  MoviesViewModel.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation
import SwiftUI

// MARK: - Movies View Model
@MainActor
final class MoviesViewModel: ObservableObject {
    @Published var popular: [Movie] = []
    @Published var topRated: [Movie] = []
    @Published var nowPlaying: [Movie] = []
    @Published var upcoming: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let fetchPopularUseCase: FetchPopularUseCaseProtocol
    private let fetchTopRatedUseCase: FetchTopRatedUseCaseProtocol
    private let fetchNowPlayingUseCase: FetchNowPlayingUseCaseProtocol
    private let fetchUpcomingUseCase: FetchUpcomingUseCaseProtocol

    init(
        fetchPopularUseCase: FetchPopularUseCaseProtocol,
        fetchTopRatedUseCase: FetchTopRatedUseCaseProtocol,
        fetchNowPlayingUseCase: FetchNowPlayingUseCaseProtocol,
        fetchUpcomingUseCase: FetchUpcomingUseCaseProtocol
    ) {
        self.fetchPopularUseCase = fetchPopularUseCase
        self.fetchTopRatedUseCase = fetchTopRatedUseCase
        self.fetchNowPlayingUseCase = fetchNowPlayingUseCase
        self.fetchUpcomingUseCase = fetchUpcomingUseCase
    }

    func loadAll() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            async let pop = fetchPopularUseCase.executeMovies(page: 1)
            async let top = fetchTopRatedUseCase.executeMovies(page: 1)
            async let now = fetchNowPlayingUseCase.execute(page: 1)
            async let up = fetchUpcomingUseCase.execute(page: 1)
            let (p, t, n, u) = try await (pop, top, now, up)
            self.popular = p
            self.topRated = t
            self.nowPlaying = n
            self.upcoming = u
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}

// MARK: - TV Shows View Model
@MainActor
final class TVShowsViewModel: ObservableObject {
    @Published var popular: [TVShow] = []
    @Published var topRated: [TVShow] = []
    @Published var onTheAir: [TVShow] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let fetchPopularUseCase: FetchPopularUseCaseProtocol
    private let fetchTopRatedUseCase: FetchTopRatedUseCaseProtocol
    private let fetchOnTheAirUseCase: FetchOnTheAirUseCaseProtocol

    init(
        fetchPopularUseCase: FetchPopularUseCaseProtocol,
        fetchTopRatedUseCase: FetchTopRatedUseCaseProtocol,
        fetchOnTheAirUseCase: FetchOnTheAirUseCaseProtocol
    ) {
        self.fetchPopularUseCase = fetchPopularUseCase
        self.fetchTopRatedUseCase = fetchTopRatedUseCase
        self.fetchOnTheAirUseCase = fetchOnTheAirUseCase
    }

    func loadAll() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            async let pop = fetchPopularUseCase.executeTVShows(page: 1)
            async let top = fetchTopRatedUseCase.executeTVShows(page: 1)
            async let air = fetchOnTheAirUseCase.execute(page: 1)
            let (p, t, a) = try await (pop, top, air)
            self.popular = p
            self.topRated = t
            self.onTheAir = a
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}
