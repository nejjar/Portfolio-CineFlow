//
//  SearchViewModel.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Search View Model
@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var movies: [Movie] = []
    @Published var tvShows: [TVShow] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let searchUseCase: SearchUseCaseProtocol
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    init(searchUseCase: SearchUseCaseProtocol) {
        self.searchUseCase = searchUseCase
        setupQueryDebounce()
    }

    private func setupQueryDebounce() {
        $query
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }

    private func performSearch(query: String) {
        searchTask?.cancel()
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.movies = []
            self.tvShows = []
            return
        }
        searchTask = Task {
            isLoading = true
            errorMessage = nil
            do {
                let results = try await searchUseCase.execute(query: query, page: 1)
                guard !Task.isCancelled else { return }
                self.movies = results.movies
                self.tvShows = results.tvShows
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
            }
            isLoading = false
        }
    }

    func clearSearch() {
        query = ""
        movies = []
        tvShows = []
    }
}
