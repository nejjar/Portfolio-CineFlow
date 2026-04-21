//
//  FetchNowPlayingUseCaseTests.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import XCTest
@testable import CineFlow

// MARK: - Fetch Now Playing Use Case Tests
@MainActor
final class FetchNowPlayingUseCaseTests: XCTestCase {
    private var movieRepository: MockMovieRepository!
    private var sut: FetchNowPlayingUseCase!

    override func setUp() {
        super.setUp()
        movieRepository = MockMovieRepository()
        sut = FetchNowPlayingUseCase(repository: movieRepository)
    }

    override func tearDown() {
        sut = nil
        movieRepository = nil
        super.tearDown()
    }

    func test_execute_success_returnsMovies() async throws {
        let expected = [Movie.stub]
        movieRepository.nowPlayingMovies = expected

        let result = try await sut.execute(page: 1)

        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result.first?.id, expected.first?.id)
    }

    func test_execute_empty_returnsEmptyArray() async throws {
        movieRepository.nowPlayingMovies = []

        let result = try await sut.execute(page: 1)

        XCTAssertTrue(result.isEmpty)
    }

    func test_execute_networkError_propagatesError() async {
        movieRepository.shouldThrow = .noInternetConnection

        do {
            _ = try await sut.execute(page: 1)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .noInternetConnection)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
