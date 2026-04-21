//
//  CinePosterImage.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - Cine Poster Image
struct CinePosterImage: View {
    let url: URL?
    var aspectRatio: CGFloat = 2/3
    var cornerRadius: CGFloat = 12

    @State private var phase: AsyncImagePhase = .empty

    var body: some View {
        AsyncImage(url: url) { loadedPhase in
            switch loadedPhase {
            case .empty:
                placeholderView.shimmer()
            case .success(let image):
                image.resizable().scaledToFill()
                    .transition(.opacity.animation(.easeIn(duration: 0.3)))
            case .failure:
                placeholderView
            @unknown default:
                placeholderView
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.cineCard)
            .overlay(
                Image(systemName: "film")
                    .font(.system(size: 28))
                    .foregroundStyle(Color.cineSubtitle)
            )
    }
}

// MARK: - Backdrop Image
struct CineBackdropImage: View {
    let url: URL?
    var cornerRadius: CGFloat = 0

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Rectangle().fill(Color.cineCard).shimmer()
            case .success(let image):
                image.resizable().scaledToFill()
                    .transition(.opacity.animation(.easeIn(duration: 0.4)))
            case .failure:
                Rectangle().fill(Color.cineCard)
                    .overlay(Image(systemName: "photo").foregroundStyle(Color.cineSubtitle))
            @unknown default:
                Rectangle().fill(Color.cineCard)
            }
        }
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
