//
//  SearchMoviesUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Use Case

protocol SearchMoviesUseCase: Sendable {

    func execute(
        query: String,
        mediaType: MediaType,
        page: Int
    ) async throws -> MoviesPage
}

// MARK: - Default Implementation

struct DefaultSearchMoviesUseCase: SearchMoviesUseCase {

    private let repository: any SearchRepository

    init(repository: any SearchRepository) {
        self.repository = repository
    }

    func execute(
        query: String,
        mediaType: MediaType,
        page: Int
    ) async throws -> MoviesPage {

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return try await repository.popular(mediaType: mediaType, page: page)
        }

        return try await repository.search(
            query: trimmed,
            mediaType: mediaType,
            page: page
        )
    }
}
