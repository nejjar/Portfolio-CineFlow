//
//  HomeViewModel.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Home View Model
@MainActor
final class HomeViewModel: ObservableObject {
    // MARK: - Published State
    @Published var featuredMovies: [Movie] = []
    @Published var trendingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var trendingTVShows: [TVShow] = []
    @Published var popularTVShows: [TVShow] = []
    @Published var topRatedMovies: [Movie] = []

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentFeaturedIndex = 0

    // MARK: - Dependencies
    private let fetchTrendingUseCase: FetchTrendingUseCaseProtocol
    private let fetchPopularUseCase: FetchPopularUseCaseProtocol
    private let fetchTopRatedUseCase: FetchTopRatedUseCaseProtocol

    // MARK: - Init
    init(
        fetchTrendingUseCase: FetchTrendingUseCaseProtocol,
        fetchPopularUseCase: FetchPopularUseCaseProtocol,
        fetchTopRatedUseCase: FetchTopRatedUseCaseProtocol
    ) {
        self.fetchTrendingUseCase = fetchTrendingUseCase
        self.fetchPopularUseCase = fetchPopularUseCase
        self.fetchTopRatedUseCase = fetchTopRatedUseCase
    }

    // MARK: - Load
    func loadAll() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            async let trendingMoviesResult = fetchTrendingUseCase.executeTrendingMovies(page: 1)
            async let trendingTVResult = fetchTrendingUseCase.executeTrendingTVShows(page: 1)
            async let popularMoviesResult = fetchPopularUseCase.executeMovies(page: 1)
            async let topRatedResult = fetchTopRatedUseCase.executeMovies(page: 1)
            async let popularTVResult = fetchPopularUseCase.executeTVShows(page: 1)

            let (tMovies, tTV, pMovies, trMovies, pTV) = try await (
                trendingMoviesResult,
                trendingTVResult,
                popularMoviesResult,
                topRatedResult,
                popularTVResult
            )

            self.trendingMovies = tMovies
            self.featuredMovies = Array(tMovies.prefix(5))
            self.trendingTVShows = tTV
            self.popularMovies = pMovies
            self.topRatedMovies = trMovies
            self.popularTVShows = pTV
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }

        isLoading = false
    }

    func advanceFeatured() {
        guard !featuredMovies.isEmpty else { return }
        currentFeaturedIndex = (currentFeaturedIndex + 1) % featuredMovies.count
    }
}
