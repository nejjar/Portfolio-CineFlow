//
//  FetchUpcomingUseCaseTests.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import XCTest
@testable import CineFlow

// MARK: - Fetch Upcoming Use Case Tests
@MainActor
final class FetchUpcomingUseCaseTests: XCTestCase {
    private var movieRepository: MockMovieRepository!
    private var sut: FetchUpcomingUseCase!

    override func setUp() {
        super.setUp()
        movieRepository = MockMovieRepository()
        sut = FetchUpcomingUseCase(repository: movieRepository)
    }

    override func tearDown() {
        sut = nil
        movieRepository = nil
        super.tearDown()
    }

    func test_execute_success_returnsMovies() async throws {
        let expected = [Movie.stub]
        movieRepository.upcomingMovies = expected

        let result = try await sut.execute(page: 1)

        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result.first?.id, expected.first?.id)
    }

    func test_execute_empty_returnsEmptyArray() async throws {
        movieRepository.upcomingMovies = []

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
