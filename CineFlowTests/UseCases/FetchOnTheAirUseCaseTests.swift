//
//  FetchOnTheAirUseCaseTests.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import XCTest
@testable import CineFlow

// MARK: - Fetch On The Air Use Case Tests
@MainActor
final class FetchOnTheAirUseCaseTests: XCTestCase {
    private var tvShowRepository: MockTVShowRepository!
    private var sut: FetchOnTheAirUseCase!

    override func setUp() {
        super.setUp()
        tvShowRepository = MockTVShowRepository()
        sut = FetchOnTheAirUseCase(repository: tvShowRepository)
    }

    override func tearDown() {
        sut = nil
        tvShowRepository = nil
        super.tearDown()
    }

    func test_execute_success_returnsShows() async throws {
        let expected = [TVShow.stub]
        tvShowRepository.onTheAirShows = expected

        let result = try await sut.execute(page: 1)

        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result.first?.id, expected.first?.id)
    }

    func test_execute_empty_returnsEmptyArray() async throws {
        tvShowRepository.onTheAirShows = []

        let result = try await sut.execute(page: 1)

        XCTAssertTrue(result.isEmpty)
    }

    func test_execute_networkError_propagatesError() async {
        tvShowRepository.shouldThrow = .noInternetConnection

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
