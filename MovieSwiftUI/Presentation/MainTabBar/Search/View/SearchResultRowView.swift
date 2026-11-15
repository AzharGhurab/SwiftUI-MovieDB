//
//  SearchResultRowView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Search Result Row View

struct SearchResultRowView: View {

    // MARK: - Properties

    let movie: MovieSummary

    let showsChevron: Bool

    // MARK: - Body

    var body: some View {
        HStack(spacing: 14) {

            // MARK: - Poster

            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Color.white.opacity(0.08)
                }
            }
            .frame(width: 66, height: 99)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            // MARK: - Info

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Label(movie.ratingText, systemImage: "star.fill")
                    .font(.subheadline)
                    .foregroundStyle(.yellow)
            }

            Spacer(minLength: 0)

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.35))
            }
        }
        .contentShape(Rectangle())
    }

    // MARK: - Subtitle

    private var subtitle: String {
        if movie.releaseYear.isEmpty {
            return movie.mediaType.singularTitle
        }

        return "\(movie.releaseYear) • \(movie.mediaType.singularTitle)"
    }
}

// MARK: - Preview

#Preview {
    SearchResultRowView(
        movie: MovieSummary(
            id: 1,
            title: "The Dark Knight",
            posterPath: nil,
            voteAverage: 8.5,
            genreIds: [],
            releaseYear: "2008"
        ),
        showsChevron: true
    )
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
