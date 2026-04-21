//
//  SearchUseCaseTests.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import XCTest
@testable import CineFlow

// MARK: - Search Use Case Tests
@MainActor
final class SearchUseCaseTests: XCTestCase {
    private var movieRepository: MockMovieRepository!
    private var tvShowRepository: MockTVShowRepository!
    private var sut: SearchUseCase!

    override func setUp() {
        super.setUp()
        movieRepository = MockMovieRepository()
        tvShowRepository = MockTVShowRepository()
        sut = SearchUseCase(movieRepository: movieRepository, tvShowRepository: tvShowRepository)
    }

    override func tearDown() {
        sut = nil
        movieRepository = nil
        tvShowRepository = nil
        super.tearDown()
    }

    func test_execute_withValidQuery_returnsBothMoviesAndShows() async throws {
        movieRepository.searchMovies = [Movie.stub]
        tvShowRepository.searchShows = [TVShow.stub]

        let result = try await sut.execute(query: "fight", page: 1)

        XCTAssertFalse(result.movies.isEmpty)
        XCTAssertFalse(result.tvShows.isEmpty)
        XCTAssertEqual(result.query, "fight")
    }

    func test_execute_withEmptyQuery_returnsEmptyResults() async throws {
        let result = try await sut.execute(query: "", page: 1)

        XCTAssertTrue(result.movies.isEmpty)
        XCTAssertTrue(result.tvShows.isEmpty)
    }

    func test_execute_withWhitespaceOnlyQuery_returnsEmptyResults() async throws {
        let result = try await sut.execute(query: "   ", page: 1)

        XCTAssertTrue(result.movies.isEmpty)
        XCTAssertTrue(result.tvShows.isEmpty)
    }

    func test_execute_withNetworkError_throwsError() async {
        movieRepository.shouldThrow = .noInternetConnection

        do {
            _ = try await sut.execute(query: "batman", page: 1)
            XCTFail("Expected error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .noInternetConnection)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_execute_trimsWhitespace() async throws {
        let result = try await sut.execute(query: "  batman  ", page: 1)

        XCTAssertEqual(result.query, "batman")
    }
}
