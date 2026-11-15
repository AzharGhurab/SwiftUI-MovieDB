//
//  DefaultSearchRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

final class DefaultSearchRepository: SearchRepository {

    // MARK: - Dependencies

    private let client: NetworkClient

    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }

    // MARK: - Search

    func search(
        query: String,
        mediaType: MediaType,
        page: Int
    ) async throws -> MoviesPage {

        switch mediaType {
        case .movie:
            let response: MoviesPageResponseDTO = try await client.request(
                MovieEndpoint.search(query: query, page: page)
            )
            return response.toDomain()

        case .tv:
            let response: TVPageResponseDTO = try await client.request(
                TVEndpoint.search(query: query, page: page)
            )
            return response.toDomain()
        }
    }

    // MARK: - Popular

    func popular(
        mediaType: MediaType,
        page: Int
    ) async throws -> MoviesPage {

        switch mediaType {
        case .movie:
            let response: MoviesPageResponseDTO = try await client.request(
                MovieEndpoint.list(category: .popular, page: page)
            )
            return response.toDomain()

        case .tv:
            let response: TVPageResponseDTO = try await client.request(
                TVEndpoint.popular(page: page)
            )
            return response.toDomain()
        }
    }
}
