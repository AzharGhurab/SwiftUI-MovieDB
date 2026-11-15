//
//  DeleteListUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Delete List Use Case

protocol DeleteListUseCase: Sendable {

    func execute(
        listID: Int,
        sessionID: String
    ) async throws
}

// MARK: - Default Implementation

struct DefaultDeleteListUseCase: DeleteListUseCase {

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
    ) async throws {
        try await repository.deleteList(
            listID: listID,
            sessionID: sessionID
        )
    }
}
