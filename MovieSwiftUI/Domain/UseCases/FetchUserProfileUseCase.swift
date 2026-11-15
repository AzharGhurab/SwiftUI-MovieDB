//
//  FetchUserProfileUseCase.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Fetch User Profile Use Case

protocol FetchUserProfileUseCase: Sendable {
    func execute(sessionID: String) async throws -> UserProfile
}

// MARK: - Default Implementation

struct DefaultFetchUserProfileUseCase: FetchUserProfileUseCase {

    private let repository: any AccountRepository

    init(repository: any AccountRepository) {
        self.repository = repository
    }

    func execute(sessionID: String) async throws -> UserProfile {
        try await repository.fetchUserProfile(sessionID: sessionID)
    }
}
