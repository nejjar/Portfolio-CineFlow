//
//  SearchViewModelTests.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import XCTest
import Combine
@testable import CineFlow

// MARK: - Search View Model Tests
@MainActor
final class SearchViewModelTests: XCTestCase {
    private var movieRepository: MockMovieRepository!
    private var tvShowRepository: MockTVShowRepository!
    private var searchUseCase: SearchUseCase!
    private var sut: SearchViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        movieRepository = MockMovieRepository()
        tvShowRepository = MockTVShowRepository()
        searchUseCase = SearchUseCase(movieRepository: movieRepository, tvShowRepository: tvShowRepository)
        sut = SearchViewModel(searchUseCase: searchUseCase)
    }

    override func tearDown() {
        cancellables.removeAll()
        sut = nil
        searchUseCase = nil
        super.tearDown()
    }

    // MARK: - Initial State
    func test_initialState_isEmpty() {
        XCTAssertEqual(sut.query, "")
        XCTAssertTrue(sut.movies.isEmpty)
        XCTAssertTrue(sut.tvShows.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    // MARK: - Clear
    func test_clearSearch_resetsState() {
        sut.query = "batman"
        sut.clearSearch()
        XCTAssertEqual(sut.query, "")
        XCTAssertTrue(sut.movies.isEmpty)
        XCTAssertTrue(sut.tvShows.isEmpty)
    }
}

// MARK: - Network Error Tests
final class NetworkErrorTests: XCTestCase {
    func test_from_statusCode_401_returnsUnauthorized() {
        XCTAssertEqual(NetworkError.from(statusCode: 401), .unauthorized)
    }

    func test_from_statusCode_404_returnsNotFound() {
        XCTAssertEqual(NetworkError.from(statusCode: 404), .notFound)
    }

    func test_from_statusCode_500_returnsHTTPError() {
        if case .httpError(let code) = NetworkError.from(statusCode: 500) {
            XCTAssertEqual(code, 500)
        } else {
            XCTFail("Expected httpError(500)")
        }
    }

    func test_errorDescription_noInternet() {
        let error = NetworkError.noInternetConnection
        XCTAssertNotNil(error.errorDescription)
        XCTAssertFalse(error.errorDescription!.isEmpty)
    }

    func test_errorDescription_unauthorized() {
        let error = NetworkError.unauthorized
        XCTAssertTrue(error.errorDescription?.contains("Unauthorized") == true ||
                      error.errorDescription?.contains("API key") == true)
    }
}

// MARK: - Movie Entity Tests
final class MovieEntityTests: XCTestCase {
    func test_releaseYear_extractsYearFromDate() {
        let movie = Movie.stub
        XCTAssertEqual(movie.releaseYear, "1999")
    }

    func test_runtimeFormatted_hoursAndMinutes() {
        let movie = Movie.stub // runtime: 139
        XCTAssertEqual(movie.runtimeFormatted, "2h 19m")
    }

    func test_runtimeFormatted_nilWhenNoRuntime() {
        let movie = Movie(
            id: 1, title: "Test", overview: "", posterPath: nil, backdropPath: nil,
            releaseDate: nil, voteAverage: 7.0, voteCount: 100, popularity: 10,
            genreIDs: [], originalLanguage: "en", adult: false,
            genres: nil, runtime: nil, tagline: nil, status: nil,
            budget: nil, revenue: nil, cast: nil, videos: nil, similar: nil
        )
        XCTAssertNil(movie.runtimeFormatted)
    }
}

// MARK: - Double Extensions Tests
final class DoubleExtensionTests: XCTestCase {
    func test_starRating_convertsCorrectly() {
        XCTAssertEqual((10.0).starRating, 5.0)
        XCTAssertEqual((5.0).starRating, 2.5)
        XCTAssertEqual((0.0).starRating, 0.0)
    }

    func test_oneDecimal_formatsCorrectly() {
        XCTAssertEqual((7.456).oneDecimal, "7.5")
        XCTAssertEqual((8.0).oneDecimal, "8.0")
    }

    func test_formattedCount_thousands() {
        XCTAssertEqual(1500.formattedCount, "1.5K")
        XCTAssertEqual(999.formattedCount, "999")
        XCTAssertEqual(1_500_000.formattedCount, "1.5M")
    }
}
