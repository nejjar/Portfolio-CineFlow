//
//  FetchTrendingUseCaseTests.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import XCTest
@testable import CineFlow

// MARK: - Fetch Trending Use Case Tests
@MainActor
final class FetchTrendingUseCaseTests: XCTestCase {
    private var movieRepository: MockMovieRepository!
    private var tvShowRepository: MockTVShowRepository!
    private var sut: FetchTrendingUseCase!

    override func setUp() {
        super.setUp()
        movieRepository = MockMovieRepository()
        tvShowRepository = MockTVShowRepository()
        sut = FetchTrendingUseCase(
            movieRepository: movieRepository,
            tvShowRepository: tvShowRepository
        )
    }

    override func tearDown() {
        sut = nil
        movieRepository = nil
        tvShowRepository = nil
        super.tearDown()
    }

    // MARK: - Movies
    func test_executeTrendingMovies_success_returnsMovies() async throws {
        let expected = [Movie.stub]
        movieRepository.trendingMovies = expected

        let result = try await sut.executeTrendingMovies(page: 1)

        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result.first?.id, expected.first?.id)
    }

    func test_executeTrendingMovies_throwsNetworkError_propagatesError() async {
        movieRepository.shouldThrow = .noInternetConnection

        do {
            _ = try await sut.executeTrendingMovies(page: 1)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .noInternetConnection)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_executeTrendingMovies_emptyResult_returnsEmptyArray() async throws {
        movieRepository.trendingMovies = []

        let result = try await sut.executeTrendingMovies(page: 1)

        XCTAssertTrue(result.isEmpty)
    }

    // MARK: - TV Shows
    func test_executeTrendingTVShows_success_returnsShows() async throws {
        let expected = [TVShow.stub]
        tvShowRepository.trendingShows = expected

        let result = try await sut.executeTrendingTVShows(page: 1)

        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result.first?.id, expected.first?.id)
    }

    func test_executeTrendingTVShows_throwsUnauthorized_propagatesError() async {
        tvShowRepository.shouldThrow = .unauthorized

        do {
            _ = try await sut.executeTrendingTVShows(page: 1)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_executeTrendingTVShows_multiplePages() async throws {
        let page1 = [TVShow.stub]
        tvShowRepository.trendingShows = page1

        let result = try await sut.executeTrendingTVShows(page: 2)

        XCTAssertEqual(result.count, page1.count)
    }
}
