//
//  WatchlistView.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI
import SwiftData

// MARK: - Watchlist View
struct WatchlistView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var coordinator: AppCoordinator
    @Query(sort: \WatchlistItem.addedAt, order: .reverse) private var items: [WatchlistItem]
    @State private var filter: MediaType? = nil
    @State private var selectedItem: WatchlistItem?

    private var filteredItems: [WatchlistItem] {
        guard let filter else { return items }
        return items.filter { $0.mediaType == filter }
    }

    var body: some View {
        ZStack {
            Color.cineDark.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                    .padding(.top, 60)

                if items.isEmpty {
                    emptyState
                } else {
                    filterBar
                    itemsList
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("watchlistView")
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Watchlist")
                    .font(.system(size: 26, weight: .black))
                    .foregroundStyle(.white)
                Text("\(items.count) title\(items.count == 1 ? "" : "s")")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.cineSubtitle)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    // MARK: - Filter Bar
    private var filterBar: some View {
        HStack(spacing: 8) {
            filterChip(title: "All", type: nil)
            filterChip(title: "Movies", type: .movie)
            filterChip(title: "Series", type: .tvShow)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    private func filterChip(title: String, type: MediaType?) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) { filter = type }
        } label: {
            Text(title)
                .font(.system(size: 13, weight: filter == type ? .bold : .medium))
                .foregroundStyle(filter == type ? .white : Color.cineSubtitle)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Capsule().fill(filter == type ? Color.cineAccent : Color.cineCard))
        }
    }

    // MARK: - Items List
    private var itemsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(Array(filteredItems.enumerated()), id: \.element.id) { index, item in
                    watchlistRow(item: item, index: index)
                }
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
        }
    }

    private func watchlistRow(item: WatchlistItem, index: Int) -> some View {
        Button {
            if item.mediaType == .movie {
                let movie = Movie(
                    id: item.mediaId, title: item.title, overview: "",
                    posterPath: item.posterPath, backdropPath: item.backdropPath,
                    releaseDate: item.releaseYear.map { "\($0)-01-01" },
                    voteAverage: item.voteAverage, voteCount: 0, popularity: 0,
                    genreIDs: [], originalLanguage: "en", adult: false,
                    genres: nil, runtime: nil, tagline: nil, status: nil,
                    budget: nil, revenue: nil, cast: nil, videos: nil, similar: nil
                )
                coordinator.push(.movieDetail(movie))
            } else {
                let show = TVShow(
                    id: item.mediaId, name: item.title, overview: "",
                    posterPath: item.posterPath, backdropPath: item.backdropPath,
                    firstAirDate: item.releaseYear.map { "\($0)-01-01" },
                    voteAverage: item.voteAverage, voteCount: 0, popularity: 0,
                    genreIDs: [], originalLanguage: "en",
                    genres: nil, numberOfSeasons: nil, numberOfEpisodes: nil,
                    episodeRunTime: nil, status: nil, tagline: nil,
                    cast: nil, videos: nil, similar: nil, networks: nil
                )
                coordinator.push(.tvShowDetail(show))
            }
        } label: {
            HStack(spacing: 14) {
                CinePosterImage(url: item.posterPath.tmdbPosterURL())
                    .frame(width: 70, height: 105)
                    .cardShadow()

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        MediaTypeBadge(mediaType: item.mediaType)
                        Spacer()
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                context.delete(item)
                            }
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 15))
                                .foregroundStyle(Color.cineAccent)
                        }
                    }
                    Text(item.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    HStack(spacing: 6) {
                        RatingBadge(rating: item.voteAverage, compact: true)
                        if let year = item.releaseYear {
                            Text(year).font(.system(size: 12)).foregroundStyle(Color.cineSubtitle)
                        }
                    }

                    Text("Added \(item.addedAt.formatted(.relative(presentation: .named)))")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.cineSubtitle)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cineCard)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.cineBorder, lineWidth: 0.5))
            )
        }
        .buttonStyle(PressScaleButtonStyle())
        .fadeInOnAppear(delay: Double(index) * 0.04)
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.cineAccent.opacity(0.1))
                    .frame(width: 100, height: 100)
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.cineAccent.opacity(0.6))
            }
            Text("Your watchlist is empty")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            Text("Add movies and series to keep track of what you want to watch")
                .font(.system(size: 14))
                .foregroundStyle(Color.cineSubtitle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button {
                coordinator.navigate(to: .home)
            } label: {
                Text("Discover Content")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Color.cineAccent))
            }
            Spacer()
        }
    }
}
#Preview("Watchlist - Empty") {
    WatchlistView()
        .environmentObject(PreviewCoordinator())
        .modelContainer(for: WatchlistItem.self, inMemory: true)
}

#Preview("Watchlist - With Items") {
    @Previewable @State var container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: WatchlistItem.self, configurations: config)
        
        // Add sample items
        let item1 = WatchlistItem(
            id: 550,
            title: "Fight Club",
            posterPath: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
            backdropPath: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
            voteAverage: 8.4,
            releaseYear: "1999",
            mediaType: .movie
        )
        
        let item2 = WatchlistItem(
            id: 1399,
            title: "Game of Thrones",
            posterPath: "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg",
            backdropPath: "/suopoADq0k8YZr4dQXcU6pToj6s.jpg",
            voteAverage: 8.4,
            releaseYear: "2011",
            mediaType: .tvShow
        )
        
        container.mainContext.insert(item1)
        container.mainContext.insert(item2)
        
        return container
    }()
    
    WatchlistView()
        .environmentObject(PreviewCoordinator())
        .modelContainer(container)
}

