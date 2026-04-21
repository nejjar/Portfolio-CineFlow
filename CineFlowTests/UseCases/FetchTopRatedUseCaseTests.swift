//
//  FetchTopRatedUseCaseTests.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import XCTest
@testable import CineFlow

// MARK: - Fetch Top Rated Use Case Tests
@MainActor
final class FetchTopRatedUseCaseTests: XCTestCase {
    private var movieRepository: MockMovieRepository!
    private var tvShowRepository: MockTVShowRepository!
    private var sut: FetchTopRatedUseCase!

    override func setUp() {
        super.setUp()
        movieRepository = MockMovieRepository()
        tvShowRepository = MockTVShowRepository()
        sut = FetchTopRatedUseCase(movieRepository: movieRepository, tvShowRepository: tvShowRepository)
    }

    override func tearDown() {
        sut = nil
        movieRepository = nil
        tvShowRepository = nil
        super.tearDown()
    }

    // MARK: - Movies
    func test_executeMovies_success_returnsMovies() async throws {
        let expected = [Movie.stub]
        movieRepository.topRatedMovies = expected

        let result = try await sut.executeMovies(page: 1)

        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result.first?.id, expected.first?.id)
    }

    func test_executeMovies_empty_returnsEmptyArray() async throws {
        movieRepository.topRatedMovies = []

        let result = try await sut.executeMovies(page: 1)

        XCTAssertTrue(result.isEmpty)
    }

    func test_executeMovies_networkError_propagatesError() async {
        movieRepository.shouldThrow = .noInternetConnection

        do {
            _ = try await sut.executeMovies(page: 1)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .noInternetConnection)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // MARK: - TV Shows
    func test_executeTVShows_success_returnsShows() async throws {
        let expected = [TVShow.stub]
        tvShowRepository.topRatedShows = expected

        let result = try await sut.executeTVShows(page: 1)

        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result.first?.id, expected.first?.id)
    }

    func test_executeTVShows_empty_returnsEmptyArray() async throws {
        tvShowRepository.topRatedShows = []

        let result = try await sut.executeTVShows(page: 1)

        XCTAssertTrue(result.isEmpty)
    }

    func test_executeTVShows_networkError_propagatesError() async {
        tvShowRepository.shouldThrow = .unauthorized

        do {
            _ = try await sut.executeTVShows(page: 1)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
