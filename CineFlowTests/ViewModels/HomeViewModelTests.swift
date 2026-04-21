//
//  HomeViewModelTests.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import XCTest
import Combine
@testable import CineFlow

// MARK: - Home View Model Tests
@MainActor
final class HomeViewModelTests: XCTestCase {
    private var movieRepository: MockMovieRepository!
    private var tvShowRepository: MockTVShowRepository!
    private var sut: HomeViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        movieRepository = MockMovieRepository()
        tvShowRepository = MockTVShowRepository()

        let trendingUseCase = FetchTrendingUseCase(
            movieRepository: movieRepository,
            tvShowRepository: tvShowRepository
        )
        let popularUseCase = FetchPopularUseCase(
            movieRepository: movieRepository,
            tvShowRepository: tvShowRepository
        )
        let topRatedUseCase = FetchTopRatedUseCase(
            movieRepository: movieRepository,
            tvShowRepository: tvShowRepository
        )

        sut = HomeViewModel(
            fetchTrendingUseCase: trendingUseCase,
            fetchPopularUseCase: popularUseCase,
            fetchTopRatedUseCase: topRatedUseCase
        )
    }

    override func tearDown() {
        cancellables.removeAll()
        sut = nil
        super.tearDown()
    }

    // MARK: - Initial State
    func test_initialState_isNotLoading() {
        XCTAssertFalse(sut.isLoading)
    }

    func test_initialState_hasEmptyCollections() {
        XCTAssertTrue(sut.trendingMovies.isEmpty)
        XCTAssertTrue(sut.trendingTVShows.isEmpty)
        XCTAssertTrue(sut.popularMovies.isEmpty)
        XCTAssertTrue(sut.popularTVShows.isEmpty)
        XCTAssertTrue(sut.featuredMovies.isEmpty)
        XCTAssertNil(sut.errorMessage)
    }

    // MARK: - Load All
    func test_loadAll_success_populatesCollections() async {
        let movies = [Movie.stub]
        let shows = [TVShow.stub]
        movieRepository.trendingMovies = movies
        tvShowRepository.trendingShows = shows

        await sut.loadAll()

        XCTAssertFalse(sut.trendingMovies.isEmpty)
        XCTAssertFalse(sut.trendingTVShows.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func test_loadAll_success_setsFeaturedMovies() async {
        movieRepository.trendingMovies = Array(repeating: Movie.stub, count: 5)

        await sut.loadAll()

        XCTAssertEqual(sut.featuredMovies.count, 5)
    }

    func test_loadAll_networkError_setsErrorMessage() async {
        movieRepository.shouldThrow = .noInternetConnection

        await sut.loadAll()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadAll_unauthorized_setsAuthErrorMessage() async {
        movieRepository.shouldThrow = .unauthorized

        await sut.loadAll()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains("Unauthorized") == true || sut.errorMessage?.contains("API key") == true)
    }

    func test_loadAll_doesNotLoadAgainWhileLoading() async {
        let task1 = Task { await self.sut.loadAll() }
        let task2 = Task { await self.sut.loadAll() }
        await task1.value
        await task2.value
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Advance Featured
    func test_advanceFeatured_cyclesIndex() async {
        movieRepository.trendingMovies = Array(repeating: Movie.stub, count: 3)
        await sut.loadAll()

        sut.currentFeaturedIndex = 0
        sut.advanceFeatured()
        XCTAssertEqual(sut.currentFeaturedIndex, 1)
        sut.advanceFeatured()
        XCTAssertEqual(sut.currentFeaturedIndex, 2)
        sut.advanceFeatured()
        XCTAssertEqual(sut.currentFeaturedIndex, 0)
    }

    func test_advanceFeatured_doesNothingWhenEmpty() {
        sut.currentFeaturedIndex = 0
        sut.advanceFeatured()
        XCTAssertEqual(sut.currentFeaturedIndex, 0)
    }
}
