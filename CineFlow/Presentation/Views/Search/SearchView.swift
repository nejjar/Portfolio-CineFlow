//
//  SearchView.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - Search View
struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    @FocusState private var isSearchFocused: Bool
    @State private var selectedSegment: SearchSegment = .all

    enum SearchSegment: String, CaseIterable {
        case all = "All"
        case movies = "Movies"
        case series = "Series"
    }

    init(viewModel: SearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.cineDark.ignoresSafeArea()

            VStack(spacing: 0) {
                searchHeader
                    .padding(.top, 60)

                if !viewModel.query.isEmpty {
                    segmentPicker
                }

                if viewModel.isLoading {
                    loadingState
                } else if viewModel.query.isEmpty {
                    emptyState
                } else if viewModel.movies.isEmpty && viewModel.tvShows.isEmpty {
                    noResultsState
                } else {
                    resultsList
                }
            }
        }
        .onAppear { isSearchFocused = true }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("searchView")
    }

    // MARK: - Search Header
    private var searchHeader: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(isSearchFocused ? Color.cineAccent : Color.cineSubtitle)
                    .animation(.easeInOut(duration: 0.2), value: isSearchFocused)
                TextField("Movies, series, actors...", text: $viewModel.query)
                    .foregroundStyle(.white)
                    .focused($isSearchFocused)
                    .submitLabel(.search)
                    .accessibilityIdentifier("searchField")
                if !viewModel.query.isEmpty {
                    Button { viewModel.clearSearch() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.cineSubtitle)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.cineCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSearchFocused ? Color.cineAccent.opacity(0.5) : Color.cineBorder, lineWidth: 1)
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isSearchFocused)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    // MARK: - Segment Picker
    private var segmentPicker: some View {
        HStack(spacing: 8) {
            ForEach(SearchSegment.allCases, id: \.self) { segment in
                Button {
                    withAnimation(.spring(response: 0.3)) { selectedSegment = segment }
                } label: {
                    Text(segment.rawValue)
                        .font(.system(size: 13, weight: selectedSegment == segment ? .bold : .medium))
                        .foregroundStyle(selectedSegment == segment ? .white : Color.cineSubtitle)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(selectedSegment == segment ? Color.cineAccent : Color.cineCard)
                        )
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }

    // MARK: - Results
    private var resultsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                let showMovies = selectedSegment == .all || selectedSegment == .movies
                let showSeries = selectedSegment == .all || selectedSegment == .series

                if showMovies && !viewModel.movies.isEmpty {
                    SectionHeader(title: "Movies (\(viewModel.movies.count))")
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                    ForEach(Array(viewModel.movies.enumerated()), id: \.element.id) { index, movie in
                        Button {
                            coordinator.push(.movieDetail(movie))
                        } label: {
                            WideMediaCard(
                                posterURL: movie.posterPath.tmdbPosterURL(),
                                backdropURL: movie.backdropPath.tmdbBackdropURL(),
                                title: movie.title,
                                overview: movie.overview,
                                rating: movie.voteAverage,
                                year: movie.releaseYear,
                                genres: [],
                                mediaType: .movie
                            )
                            .padding(.horizontal, 20)
                            .fadeInOnAppear(delay: Double(index) * 0.03)
                        }
                        .buttonStyle(PressScaleButtonStyle())
                    }
                }

                if showSeries && !viewModel.tvShows.isEmpty {
                    SectionHeader(title: "Series (\(viewModel.tvShows.count))")
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    ForEach(Array(viewModel.tvShows.enumerated()), id: \.element.id) { index, show in
                        Button {
                            coordinator.push(.tvShowDetail(show))
                        } label: {
                            WideMediaCard(
                                posterURL: show.posterPath.tmdbPosterURL(),
                                backdropURL: show.backdropPath.tmdbBackdropURL(),
                                title: show.name,
                                overview: show.overview,
                                rating: show.voteAverage,
                                year: show.firstAirYear,
                                genres: [],
                                mediaType: .tvShow
                            )
                            .padding(.horizontal, 20)
                            .fadeInOnAppear(delay: Double(index) * 0.03)
                        }
                        .buttonStyle(PressScaleButtonStyle())
                    }
                }

                Spacer(minLength: 40)
            }
            .padding(.vertical, 4)
        }
    }

    private var loadingState: some View {
        VStack(spacing: 12) {
            ForEach(0..<5, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cineCard)
                    .frame(height: 110)
                    .shimmer()
                    .padding(.horizontal, 20)
            }
        }
        .padding(.top, 8)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "popcorn.fill")
                .font(.system(size: 56))
                .foregroundStyle(Color.cineSubtitle)
            Text("Find your next watch")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            Text("Search for movies, TV shows, or actors")
                .font(.system(size: 14))
                .foregroundStyle(Color.cineSubtitle)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, 40)
    }

    private var noResultsState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(Color.cineSubtitle)
            Text("No results found")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            Text("Try a different search term")
                .font(.system(size: 14))
                .foregroundStyle(Color.cineSubtitle)
            Spacer()
        }
    }
}
#Preview("Search View - Empty") {
    SearchView(viewModel: SearchViewModel(searchUseCase: MockSearchUseCase()))
        .environmentObject(PreviewCoordinator())
}

#Preview("Search View - With Results") {
    let viewModel = SearchViewModel(searchUseCase: MockSearchUseCase())
    viewModel.query = "Star Wars"
    viewModel.movies = [.stub, .stub, .stub]
    viewModel.tvShows = [.stub, .stub]
    return SearchView(viewModel: viewModel)
        .environmentObject(PreviewCoordinator())
}

#Preview("Search View - Loading") {
    let viewModel = SearchViewModel(searchUseCase: MockSearchUseCase())
    viewModel.query = "Marvel"
    viewModel.isLoading = true
    return SearchView(viewModel: viewModel)
        .environmentObject(PreviewCoordinator())
}

