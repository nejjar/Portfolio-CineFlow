//
//  DetailView.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI
import SwiftData

// MARK: - Movie Detail View
struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var headerOffset: CGFloat = 0
    @State private var showFullOverview = false

    init(viewModel: MovieDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.cineDark.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    backdropSection
                    contentSection
                }
            }
            .ignoresSafeArea(edges: .top)

            navBar
        }
        .navigationBarHidden(true)
        .task { await viewModel.loadDetails(context: context) }
    }

    // MARK: - Backdrop
    private var backdropSection: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geo in
                let offset = geo.frame(in: .global).minY
                CineBackdropImage(url: viewModel.movie.backdropPath.tmdbBackdropURL())
                    .frame(width: geo.size.width, height: max(300, 320 - offset * 0.5))
                    .offset(y: offset > 0 ? -offset * 0.5 : 0)
                    .overlay(Color.heroOverlayGradient)
            }
            .frame(height: 320)

            VStack(alignment: .leading, spacing: 12) {
                if viewModel.isLoading {
                    RoundedRectangle(cornerRadius: 8).fill(Color.cineCard).shimmer()
                        .frame(width: 200, height: 28)
                } else {
                    Text(viewModel.movie.title)
                        .font(.system(size: 26, weight: .black))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.6), radius: 4)
                }

                HStack(spacing: 10) {
                    RatingBadge(rating: viewModel.movie.voteAverage)
                    if let year = viewModel.movie.releaseYear {
                        Text(year).font(.system(size: 13)).foregroundStyle(Color.cineSubtitle)
                    }
                    if let runtime = viewModel.movie.runtimeFormatted {
                        Text("•").foregroundStyle(Color.cineSubtitle)
                        Text(runtime).font(.system(size: 13)).foregroundStyle(Color.cineSubtitle)
                    }
                }

                if let genres = viewModel.movie.genres, !genres.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(genres) { GenreTag(name: $0.name) }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Content
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Tagline
            if let tagline = viewModel.movie.tagline, !tagline.isEmpty {
                Text("\"\(tagline)\"")
                    .font(.system(size: 14, weight: .medium, design: .serif))
                    .italic()
                    .foregroundStyle(Color.cineSubtitle)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
            }

            // Overview
            VStack(alignment: .leading, spacing: 8) {
                Text("Overview")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                Text(viewModel.movie.overview.isEmpty ? "No overview available." : viewModel.movie.overview)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .lineLimit(showFullOverview ? nil : 4)
                    .animation(.easeInOut, value: showFullOverview)
                if viewModel.movie.overview.count > 200 {
                    Button(showFullOverview ? "Show less" : "Read more") {
                        withAnimation { showFullOverview.toggle() }
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cineAccent)
                }
            }

            // Stats Row
            if viewModel.movie.budget != nil || viewModel.movie.revenue != nil {
                statsRow
            }

            // Cast
            if let cast = viewModel.movie.cast, !cast.isEmpty {
                castSection(cast)
            }

            // Similar
            if let similar = viewModel.movie.similar, !similar.isEmpty {
                similarMoviesSection(similar)
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private var statsRow: some View {
        HStack(spacing: 0) {
            if let budget = viewModel.movie.budget, budget > 0 {
                StatBox(title: "Budget", value: formatCurrency(budget))
                Divider().background(Color.cineBorder).frame(height: 40)
            }
            if let revenue = viewModel.movie.revenue, revenue > 0 {
                StatBox(title: "Revenue", value: formatCurrency(revenue))
                Divider().background(Color.cineBorder).frame(height: 40)
            }
            StatBox(title: "Votes", value: viewModel.movie.voteCount.formattedCount)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.cineCard))
    }

    private func castSection(_ cast: [CastMember]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Cast")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(cast) { member in
                        CastCard(member: member)
                            .fadeInOnAppear(delay: Double(cast.firstIndex(of: member) ?? 0) * 0.04)
                    }
                }
            }
        }
    }

    private func similarMoviesSection(_ movies: [Movie]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Similar Movies")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(movies) { movie in
                        Button { coordinator.push(.movieDetail(movie)) } label: {
                            MediaCard(
                                posterURL: movie.posterPath.tmdbPosterURL(),
                                title: movie.title,
                                year: movie.releaseYear,
                                rating: movie.voteAverage,
                                width: 100
                            )
                        }
                        .buttonStyle(PressScaleButtonStyle())
                    }
                }
            }
        }
    }

    // MARK: - Nav Bar
    private var navBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(.ultraThinMaterial))
            }
            Spacer()
            Button {
                viewModel.toggleWatchlist(context: context)
            } label: {
                Image(systemName: viewModel.isInWatchlist ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(viewModel.isInWatchlist ? Color.cineAccent : .white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(.ultraThinMaterial))
                    .animation(.spring(response: 0.3), value: viewModel.isInWatchlist)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 56)
    }

    private func formatCurrency(_ value: Int) -> String {
        let formatted = Double(value) / 1_000_000
        return String(format: "$%.0fM", formatted)
    }
}

// MARK: - TV Show Detail View
struct TVShowDetailView: View {
    @StateObject private var viewModel: TVShowDetailViewModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var showFullOverview = false

    init(viewModel: TVShowDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.cineDark.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    backdropSection
                    contentSection
                }
            }
            .ignoresSafeArea(edges: .top)
            navBar
        }
        .navigationBarHidden(true)
        .task { await viewModel.loadDetails(context: context) }
    }

    private var backdropSection: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geo in
                let offset = geo.frame(in: .global).minY
                CineBackdropImage(url: viewModel.tvShow.backdropPath.tmdbBackdropURL())
                    .frame(width: geo.size.width, height: max(300, 320 - offset * 0.5))
                    .offset(y: offset > 0 ? -offset * 0.5 : 0)
                    .overlay(Color.heroOverlayGradient)
            }
            .frame(height: 320)

            VStack(alignment: .leading, spacing: 12) {
                Text(viewModel.tvShow.name)
                    .font(.system(size: 26, weight: .black))
                    .foregroundStyle(.white)

                HStack(spacing: 10) {
                    RatingBadge(rating: viewModel.tvShow.voteAverage)
                    if let year = viewModel.tvShow.firstAirYear {
                        Text(year).font(.system(size: 13)).foregroundStyle(Color.cineSubtitle)
                    }
                    if let seasons = viewModel.tvShow.numberOfSeasons {
                        Text("•").foregroundStyle(Color.cineSubtitle)
                        Text("\(seasons) Season\(seasons == 1 ? "" : "s")")
                            .font(.system(size: 13)).foregroundStyle(Color.cineSubtitle)
                    }
                }

                if let genres = viewModel.tvShow.genres, !genres.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) { ForEach(genres) { GenreTag(name: $0.name) } }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let tagline = viewModel.tvShow.tagline, !tagline.isEmpty {
                Text("\"\(tagline)\"")
                    .font(.system(size: 14, weight: .medium, design: .serif))
                    .italic()
                    .foregroundStyle(Color.cineSubtitle)
                    .frame(maxWidth: .infinity)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Overview")
                    .font(.system(size: 17, weight: .bold)).foregroundStyle(.white)
                Text(viewModel.tvShow.overview.isEmpty ? "No overview available." : viewModel.tvShow.overview)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .lineLimit(showFullOverview ? nil : 4)
                if viewModel.tvShow.overview.count > 200 {
                    Button(showFullOverview ? "Show less" : "Read more") {
                        withAnimation { showFullOverview.toggle() }
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cineAccent)
                }
            }

            statsRow

            if let cast = viewModel.tvShow.cast, !cast.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Cast")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) { ForEach(cast) { CastCard(member: $0) } }
                    }
                }
            }

            if let similar = viewModel.tvShow.similar, !similar.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Similar Series")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(similar) { show in
                                Button { coordinator.push(.tvShowDetail(show)) } label: {
                                    MediaCard(
                                        posterURL: show.posterPath.tmdbPosterURL(),
                                        title: show.name,
                                        year: show.firstAirYear,
                                        rating: show.voteAverage,
                                        width: 100
                                    )
                                }
                                .buttonStyle(PressScaleButtonStyle())
                            }
                        }
                    }
                }
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private var statsRow: some View {
        HStack(spacing: 0) {
            if let eps = viewModel.tvShow.numberOfEpisodes {
                StatBox(title: "Episodes", value: "\(eps)")
                Divider().background(Color.cineBorder).frame(height: 40)
            }
            StatBox(title: "Votes", value: viewModel.tvShow.voteCount.formattedCount)
            if let status = viewModel.tvShow.status {
                Divider().background(Color.cineBorder).frame(height: 40)
                StatBox(title: "Status", value: status)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.cineCard))
    }

    private var navBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(.ultraThinMaterial))
            }
            Spacer()
            Button { viewModel.toggleWatchlist(context: context) } label: {
                Image(systemName: viewModel.isInWatchlist ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(viewModel.isInWatchlist ? Color.cineAccent : .white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(.ultraThinMaterial))
                    .animation(.spring(response: 0.3), value: viewModel.isInWatchlist)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 56)
    }
}

// MARK: - Cast Card
struct CastCard: View {
    let member: CastMember

    var body: some View {
        VStack(spacing: 6) {
            AsyncImage(url: member.profilePath?.tmdbProfileURL()) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
                default:
                    Circle().fill(Color.cineCard)
                        .overlay(Image(systemName: "person.fill").foregroundStyle(Color.cineSubtitle))
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(Circle())

            Text(member.name)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            Text(member.character)
                .font(.system(size: 10))
                .foregroundStyle(Color.cineSubtitle)
                .lineLimit(1)
        }
        .frame(width: 72)
    }
}

// MARK: - Stat Box
struct StatBox: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(.system(size: 11))
                .foregroundStyle(Color.cineSubtitle)
        }
        .frame(maxWidth: .infinity)
    }
}
#Preview("Movie Detail") {
    @Previewable @State var container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: WatchlistItem.self, configurations: config)
    }()

    MovieDetailView(
        viewModel: MovieDetailViewModel(
            movie: .stub,
            fetchDetailUseCase: MockFetchDetailUseCase(),
            watchlistUseCase: MockWatchlistUseCase()
        )
    )
    .environmentObject(PreviewCoordinator())
    .modelContainer(container)
}

#Preview("TV Show Detail") {
    @Previewable @State var container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: WatchlistItem.self, configurations: config)
    }()

    TVShowDetailView(
        viewModel: TVShowDetailViewModel(
            tvShow: .stub,
            fetchDetailUseCase: MockFetchDetailUseCase(),
            watchlistUseCase: MockWatchlistUseCase()
        )
    )
    .environmentObject(PreviewCoordinator())
    .modelContainer(container)
}

