//
//  CreateListUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Create List Use Case

protocol CreateListUseCase: Sendable {

    func execute(
        name: String,
        description: String,
        sessionID: String
    ) async throws -> Int
}

// MARK: - Default Implementation

struct DefaultCreateListUseCase: CreateListUseCase {

    // MARK: - Dependencies

    private let repository: any AccountRepository

    // MARK: - Initialization

    init(repository: any AccountRepository) {
        self.repository = repository
    }

    // MARK: - Execute

    func execute(
        name: String,
        description: String,
        sessionID: String
    ) async throws -> Int {
        try await repository.createList(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            sessionID: sessionID
        )
    }
}
