//
//  ListDetailsView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 04/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - List Details View

struct ListDetailsView: View {

    // MARK: - Properties

    let title: String
    let state: ListDetailsViewModel.State
    let onRetry: () -> Void

    // MARK: - Layout

    private let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 16, alignment: .top)
    ]

    // MARK: - Body

    var body: some View {
        Group {
            switch state {

            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .loaded(let details):
                if details.movies.isEmpty {
                    emptyView
                } else {
                    grid(details.movies)
                }

            case .failed(let message):
                ContentUnavailableView {
                    Label("Something went wrong", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(message)
                } actions: {
                    Button("Retry", action: onRetry)
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .environment(\.colorScheme, .dark)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Grid

    private func grid(_ movies: [MovieSummary]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(movies) { movie in
                    movieItem(movie)
                }
            }
            .padding(16)
        }
    }

    private func movieItem(_ movie: MovieSummary) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                default:
                    ZStack {
                        Color(.tertiarySystemFill)

                        Image(systemName: "photo.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .aspectRatio(2.0 / 3.0, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            Text(movie.title)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
    }

    // MARK: - Empty

    private var emptyView: some View {
        ContentUnavailableView {
            Label("No Movies Yet", systemImage: "film")
        } description: {
            Text("Movies you add to this list will appear here.")
        }
    }
}

// MARK: - Preview

#Preview("Loaded") {
    NavigationStack {
        ListDetailsView(
            title: "Weekend Watchlist",
            state: .loaded(
                UserListDetails(
                    id: 1,
                    name: "Weekend Watchlist",
                    description: "",
                    movies: [
                        MovieSummary(id: 1, title: "Inception", posterPath: nil, voteAverage: 8.8, genreIds: []),
                        MovieSummary(id: 2, title: "Interstellar", posterPath: nil, voteAverage: 8.6, genreIds: [])
                    ]
                )
            ),
            onRetry: {}
        )
    }
}

#Preview("Empty") {
    NavigationStack {
        ListDetailsView(
            title: "Layan",
            state: .loaded(UserListDetails(id: 1, name: "Layan", description: "", movies: [])),
            onRetry: {}
        )
    }
}
