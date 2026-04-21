//
//  PreviewMocks.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation
import SwiftUI
import SwiftData

#if DEBUG

// MARK: - Mock Use Cases for Previews

final class MockFetchTrendingUseCase: FetchTrendingUseCaseProtocol {
    func executeTrendingMovies(page: Int) async throws -> [Movie] { [.stub, .stub, .stub] }
    func executeTrendingTVShows(page: Int) async throws -> [TVShow] { [.stub, .stub, .stub] }
}

final class MockFetchPopularUseCase: FetchPopularUseCaseProtocol {
    func executeMovies(page: Int) async throws -> [Movie] { [.stub, .stub, .stub] }
    func executeTVShows(page: Int) async throws -> [TVShow] { [.stub, .stub, .stub] }
}

final class MockFetchTopRatedUseCase: FetchTopRatedUseCaseProtocol {
    func executeMovies(page: Int) async throws -> [Movie] { [.stub, .stub, .stub] }
    func executeTVShows(page: Int) async throws -> [TVShow] { [.stub, .stub, .stub] }
}

final class MockFetchNowPlayingUseCase: FetchNowPlayingUseCaseProtocol {
    func execute(page: Int) async throws -> [Movie] { [.stub, .stub, .stub] }
}

final class MockFetchUpcomingUseCase: FetchUpcomingUseCaseProtocol {
    func execute(page: Int) async throws -> [Movie] { [.stub, .stub, .stub] }
}

final class MockFetchOnTheAirUseCase: FetchOnTheAirUseCaseProtocol {
    func execute(page: Int) async throws -> [TVShow] { [.stub, .stub, .stub] }
}

final class MockFetchDetailUseCase: FetchDetailUseCaseProtocol {
    func executeMovie(id: Int) async throws -> Movie { .stub }
    func executeTVShow(id: Int) async throws -> TVShow { .stub }
}

final class MockSearchUseCase: SearchUseCaseProtocol {
    func execute(query: String, page: Int) async throws -> SearchResults {
        SearchResults(movies: [.stub, .stub], tvShows: [.stub, .stub], query: query, page: page)
    }
}

@MainActor
final class MockWatchlistUseCase: WatchlistUseCaseProtocol {
    func add(movie: Movie, context: ModelContext) {}
    func add(tvShow: TVShow, context: ModelContext) {}
    func remove(id: Int, mediaType: MediaType, context: ModelContext) {}
    func isFavorite(id: Int, mediaType: MediaType, context: ModelContext) -> Bool { false }
    func toggle(movie: Movie, context: ModelContext) {}
    func toggle(tvShow: TVShow, context: ModelContext) {}
}

// MARK: - Preview Coordinator
@MainActor
final class PreviewCoordinator: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var navigationPath = NavigationPath()

    func push(_ route: NavigationRoute) {}
    func pop() {}
    func popToRoot() {}
    func navigate(to tab: AppTab) {}
}

#endif
