//
//  FetchListDetailsUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 04/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Fetch List Details Use Case

protocol FetchListDetailsUseCase: Sendable {

    func execute(
        listID: Int,
        sessionID: String
    ) async throws -> UserListDetails
}

// MARK: - Default Implementation

struct DefaultFetchListDetailsUseCase: FetchListDetailsUseCase {

    // MARK: - Dependencies

    private let repository: any AccountRepository

    // MARK: - Initialization

    init(repository: any AccountRepository) {
        self.repository = repository
    }

    // MARK: - Execute

    func execute(
        listID: Int,
        sessionID: String
    ) async throws -> UserListDetails {
        try await repository.fetchListDetails(
            listID: listID,
            sessionID: sessionID
        )
    }
}
