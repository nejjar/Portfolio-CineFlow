//
//  SectionHeader.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var actionTitle: String? = "See All"
    var onAction: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
            if let actionTitle, let onAction {
                Button(action: onAction) {
                    HStack(spacing: 4) {
                        Text(actionTitle)
                            .font(.system(size: 13, weight: .medium))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(Color.cineAccent)
                }
            }
        }
    }
}

// MARK: - Error Banner
struct ErrorBanner: View {
    let message: String
    var onRetry: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.cineAccent)
                .font(.system(size: 18))
            Text(message)
                .font(.system(size: 13))
                .foregroundStyle(.white)
                .lineLimit(2)
            Spacer()
            if let onRetry {
                Button("Retry", action: onRetry)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cineAccent)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cineAccent.opacity(0.12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.cineAccent.opacity(0.3), lineWidth: 0.5))
        )
        .padding(.horizontal)
    }
}

// MARK: - Loading Skeleton Row
struct SkeletonRow: View {
    var count: Int = 5
    var cardWidth: CGFloat = 120

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<count, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.cineCard)
                        .frame(width: cardWidth, height: cardWidth * 1.5)
                        .shimmer()
                }
            }
            .padding(.horizontal)
        }
    }
}
