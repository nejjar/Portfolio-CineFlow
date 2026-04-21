//
//  MediaCard.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - Media Card (poster + title)
struct MediaCard: View {
    let posterURL: URL?
    let title: String
    let year: String?
    let rating: Double
    var width: CGFloat? = 120

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .bottomLeading) {
                CinePosterImage(url: posterURL, cornerRadius: 10)
                    .aspectRatio(2/3, contentMode: .fit)
                    .frame(width: width)
                RatingBadge(rating: rating, compact: true)
                    .padding(6)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                if let year {
                    Text(year)
                        .font(.system(size: 11))
                        .foregroundStyle(Color.cineSubtitle)
                }
            }
            .frame(maxWidth: width ?? .infinity, alignment: .leading)
        }
    }
}

// MARK: - Wide Media Card (horizontal)
struct WideMediaCard: View {
    let posterURL: URL?
    let backdropURL: URL?
    let title: String
    let overview: String
    let rating: Double
    let year: String?
    let genres: [String]
    var mediaType: MediaType = .movie

    var body: some View {
        HStack(spacing: 12) {
            CinePosterImage(url: posterURL, cornerRadius: 10)
                .frame(width: 80, height: 120)
                .cardShadow()

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    MediaTypeBadge(mediaType: mediaType)
                    Spacer()
                    RatingBadge(rating: rating, compact: true)
                }
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                if let year {
                    Text(year)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.cineSubtitle)
                }
                Text(overview)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.cineSubtitle)
                    .lineLimit(2)

                if !genres.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(genres.prefix(3), id: \.self) { GenreTag(name: $0) }
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cineCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.cineBorder, lineWidth: 0.5)
                )
        )
        .cardShadow()
    }
}
#Preview("Media Card") {
    MediaCard(
        posterURL: URL(string: "https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),
        title: "Fight Club",
        year: "1999",
        rating: 8.4
    )
    .background(Color.cineDark)
}

#Preview("Wide Media Card") {
    WideMediaCard(
        posterURL: URL(string: "https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),
        backdropURL: URL(string: "https://image.tmdb.org/t/p/w780/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"),
        title: "Fight Club",
        overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
        rating: 8.4,
        year: "1999",
        genres: ["Drama", "Thriller"],
        mediaType: .movie
    )
    .background(Color.cineDark)
    .padding()
}

