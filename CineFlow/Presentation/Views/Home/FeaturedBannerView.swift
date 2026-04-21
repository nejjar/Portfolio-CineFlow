//
//  FeaturedBannerView.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - Featured Banner
struct FeaturedBannerView: View {
    let movies: [Movie]
    @Binding var currentIndex: Int
    var onMovieTap: (Movie) -> Void
    var onAutoAdvance: () -> Void

    @State private var dragOffset: CGFloat = 0
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            if movies.isEmpty {
                skeletonBanner
            } else {
                GeometryReader { geo in
                    ZStack {
                        ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                            BannerSlide(movie: movie, size: geo.size)
                                .opacity(index == currentIndex ? 1 : 0)
                                .scaleEffect(index == currentIndex ? 1 : 0.95)
                                .animation(.spring(response: 0.6, dampingFraction: 0.85), value: currentIndex)
                        }

                        // Overlay: info + indicators
                        VStack {
                            Spacer()
                            bannerInfoOverlay(movies[currentIndex], width: geo.size.width)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < -50 {
                                    advance(forward: true)
                                } else if value.translation.width > 50 {
                                    advance(forward: false)
                                }
                            }
                    )
                }
            }
        }
        .frame(height: 460)
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
    }

    private func bannerInfoOverlay(_ movie: Movie, width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let tagline = movie.tagline, !tagline.isEmpty {
                Text(tagline.uppercased())
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(2)
                    .foregroundStyle(Color.cineAccent)
            }
            Text(movie.title)
                .font(.system(size: 28, weight: .black))
                .foregroundStyle(.white)
                .lineLimit(2)
                .shadow(color: .black.opacity(0.5), radius: 4)

            HStack(spacing: 10) {
                RatingBadge(rating: movie.voteAverage)
                if let year = movie.releaseYear {
                    Text(year)
                        .font(.system(size: 13))
                        .foregroundStyle(Color.cineSubtitle)
                }
                if let runtime = movie.runtimeFormatted {
                    Text("•")
                        .foregroundStyle(Color.cineSubtitle)
                    Text(runtime)
                        .font(.system(size: 13))
                        .foregroundStyle(Color.cineSubtitle)
                }
            }

            HStack(spacing: 12) {
                Button {
                    onMovieTap(movie)
                } label: {
                    Label("Details", systemImage: "info.circle.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.cineAccent))
                }

                pageIndicators
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.heroOverlayGradient)
    }

    private var pageIndicators: some View {
        HStack(spacing: 6) {
            ForEach(0..<movies.count, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? Color.cineAccent : Color.white.opacity(0.3))
                    .frame(width: index == currentIndex ? 20 : 6, height: 6)
                    .animation(.spring(response: 0.3), value: currentIndex)
            }
        }
    }

    private var skeletonBanner: some View {
        Rectangle().fill(Color.cineCard).shimmer()
    }

    private func advance(forward: Bool) {
        guard !movies.isEmpty else { return }
        stopTimer()
        withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
            if forward {
                currentIndex = (currentIndex + 1) % movies.count
            } else {
                currentIndex = (currentIndex - 1 + movies.count) % movies.count
            }
        }
        startTimer()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            Task { @MainActor in onAutoAdvance() }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Banner Slide
private struct BannerSlide: View {
    let movie: Movie
    let size: CGSize

    var body: some View {
        ZStack {
            CineBackdropImage(url: movie.backdropPath.tmdbBackdropURL())
                .frame(width: size.width, height: 460)
                .overlay(
                    LinearGradient(
                        colors: [Color.cineDark.opacity(0.2), Color.cineDark.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
        }
        .clipped()
    }
}
#Preview("Featured Banner") {
    FeaturedBannerView(
        movies: [.stub, .stub, .stub],
        currentIndex: .constant(0),
        onMovieTap: { _ in },
        onAutoAdvance: {}
    )
}

#Preview("Featured Banner - Empty") {
    FeaturedBannerView(
        movies: [],
        currentIndex: .constant(0),
        onMovieTap: { _ in },
        onAutoAdvance: {}
    )
}

