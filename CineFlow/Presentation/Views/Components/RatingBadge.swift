//
//  RatingBadge.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - Rating Badge
struct RatingBadge: View {
    let rating: Double
    var compact: Bool = false

    private var color: Color {
        switch rating {
        case 7.5...: return .green
        case 6.0..<7.5: return Color.cineGold
        default: return .orange
        }
    }

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill")
                .font(.system(size: compact ? 9 : 11))
            Text(rating.oneDecimal)
                .font(.system(size: compact ? 11 : 13, weight: .bold, design: .rounded))
        }
        .foregroundStyle(color)
        .padding(.horizontal, compact ? 6 : 8)
        .padding(.vertical, compact ? 3 : 4)
        .background(
            Capsule().fill(color.opacity(0.15))
                .overlay(Capsule().stroke(color.opacity(0.3), lineWidth: 0.5))
        )
    }
}

// MARK: - Genre Tag
struct GenreTag: View {
    let name: String

    var body: some View {
        Text(name)
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(Color.white.opacity(0.8))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 0.5))
            )
    }
}

// MARK: - Media Type Badge
struct MediaTypeBadge: View {
    let mediaType: MediaType

    var body: some View {
        Text(mediaType == .movie ? "FILM" : "SERIES")
            .font(.system(size: 9, weight: .bold))
            .tracking(1.5)
            .foregroundStyle(Color.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(mediaType == .movie ? Color.cineAccent : Color(hex: "#5C6BC0"))
            )
    }
}
#Preview("Rating Badges") {
    VStack(spacing: 16) {
        RatingBadge(rating: 8.5)
        RatingBadge(rating: 7.2)
        RatingBadge(rating: 5.5)
        RatingBadge(rating: 8.9, compact: true)
        RatingBadge(rating: 6.3, compact: true)
    }
    .padding()
    .background(Color.cineDark)
}

#Preview("Genre Tags") {
    HStack {
        GenreTag(name: "Action")
        GenreTag(name: "Sci-Fi")
        GenreTag(name: "Thriller")
    }
    .padding()
    .background(Color.cineDark)
}

#Preview("Media Type Badges") {
    HStack {
        MediaTypeBadge(mediaType: .movie)
        MediaTypeBadge(mediaType: .tvShow)
    }
    .padding()
    .background(Color.cineDark)
}

