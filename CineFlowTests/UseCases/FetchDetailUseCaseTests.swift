//
//  FetchDetailUseCaseTests.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import XCTest
@testable import CineFlow

// MARK: - Fetch Detail Use Case Tests
@MainActor
final class FetchDetailUseCaseTests: XCTestCase {
    private var movieRepository: MockMovieRepository!
    private var tvShowRepository: MockTVShowRepository!
    private var sut: FetchDetailUseCase!

    override func setUp() {
        super.setUp()
        movieRepository = MockMovieRepository()
        tvShowRepository = MockTVShowRepository()
        sut = FetchDetailUseCase(movieRepository: movieRepository, tvShowRepository: tvShowRepository)
    }

    override func tearDown() {
        sut = nil
        movieRepository = nil
        tvShowRepository = nil
        super.tearDown()
    }

    // MARK: - Movie
    func test_executeMovie_success_returnsMovie() async throws {
        let expected = Movie.stub
        movieRepository.detailMovie = expected

        let result = try await sut.executeMovie(id: expected.id)

        XCTAssertEqual(result.id, expected.id)
    }

    func test_executeMovie_networkError_propagatesError() async {
        movieRepository.shouldThrow = .noInternetConnection

        do {
            _ = try await sut.executeMovie(id: 1)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .noInternetConnection)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_executeMovie_unauthorized_propagatesError() async {
        movieRepository.shouldThrow = .unauthorized

        do {
            _ = try await sut.executeMovie(id: 1)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // MARK: - TV Show
    func test_executeTVShow_success_returnsShow() async throws {
        let expected = TVShow.stub
        tvShowRepository.detailShow = expected

        let result = try await sut.executeTVShow(id: expected.id)

        XCTAssertEqual(result.id, expected.id)
    }

    func test_executeTVShow_networkError_propagatesError() async {
        tvShowRepository.shouldThrow = .noInternetConnection

        do {
            _ = try await sut.executeTVShow(id: 1)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .noInternetConnection)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_executeTVShow_unauthorized_propagatesError() async {
        tvShowRepository.shouldThrow = .unauthorized

        do {
            _ = try await sut.executeTVShow(id: 1)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
