//
//  DependencyContainer.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Dependency Container
@MainActor
final class DependencyContainer {
    static let shared = DependencyContainer()

    // MARK: - Network
    lazy var apiClient: APIClientProtocol = APIClient.shared

    // MARK: - Repositories
    lazy var movieRepository: MovieRepositoryProtocol = MovieRepository(apiClient: apiClient)
    lazy var tvShowRepository: TVShowRepositoryProtocol = TVShowRepository(apiClient: apiClient)

    // MARK: - Use Cases
    lazy var fetchTrendingUseCase: FetchTrendingUseCaseProtocol = FetchTrendingUseCase(
        movieRepository: movieRepository,
        tvShowRepository: tvShowRepository
    )
    lazy var fetchPopularUseCase: FetchPopularUseCaseProtocol = FetchPopularUseCase(
        movieRepository: movieRepository,
        tvShowRepository: tvShowRepository
    )
    lazy var fetchTopRatedUseCase: FetchTopRatedUseCaseProtocol = FetchTopRatedUseCase(
        movieRepository: movieRepository,
        tvShowRepository: tvShowRepository
    )
    lazy var fetchNowPlayingUseCase: FetchNowPlayingUseCaseProtocol = FetchNowPlayingUseCase(repository: movieRepository)
    lazy var fetchUpcomingUseCase: FetchUpcomingUseCaseProtocol = FetchUpcomingUseCase(repository: movieRepository)
    lazy var fetchOnTheAirUseCase: FetchOnTheAirUseCaseProtocol = FetchOnTheAirUseCase(repository: tvShowRepository)
    lazy var fetchDetailUseCase: FetchDetailUseCaseProtocol = FetchDetailUseCase(
        movieRepository: movieRepository,
        tvShowRepository: tvShowRepository
    )
    lazy var searchUseCase: SearchUseCaseProtocol = SearchUseCase(
        movieRepository: movieRepository,
        tvShowRepository: tvShowRepository
    )
    lazy var watchlistUseCase: WatchlistUseCaseProtocol = WatchlistUseCase()

    // MARK: - View Model Factories
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchTrendingUseCase: fetchTrendingUseCase,
            fetchPopularUseCase: fetchPopularUseCase,
            fetchTopRatedUseCase: fetchTopRatedUseCase
        )
    }

    func makeMoviesViewModel() -> MoviesViewModel {
        MoviesViewModel(
            fetchPopularUseCase: fetchPopularUseCase,
            fetchTopRatedUseCase: fetchTopRatedUseCase,
            fetchNowPlayingUseCase: fetchNowPlayingUseCase,
            fetchUpcomingUseCase: fetchUpcomingUseCase
        )
    }

    func makeTVShowsViewModel() -> TVShowsViewModel {
        TVShowsViewModel(
            fetchPopularUseCase: fetchPopularUseCase,
            fetchTopRatedUseCase: fetchTopRatedUseCase,
            fetchOnTheAirUseCase: fetchOnTheAirUseCase
        )
    }

    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(searchUseCase: searchUseCase)
    }

    func makeMovieDetailViewModel(movie: Movie) -> MovieDetailViewModel {
        MovieDetailViewModel(
            movie: movie,
            fetchDetailUseCase: fetchDetailUseCase,
            watchlistUseCase: watchlistUseCase
        )
    }

    func makeTVShowDetailViewModel(tvShow: TVShow) -> TVShowDetailViewModel {
        TVShowDetailViewModel(
            tvShow: tvShow,
            fetchDetailUseCase: fetchDetailUseCase,
            watchlistUseCase: watchlistUseCase
        )
    }
}
