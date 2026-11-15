//
//  ProfileViewModel.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Combine

// MARK: - Profile ViewModel

@MainActor
final class ProfileViewModel: ObservableObject {

    // MARK: - State

    enum State: Equatable {
        case guest
        case loading
        case signedIn(UserProfile)
        case failed(String)
    }

    @Published private(set) var state: State = .loading

    // MARK: - Dependencies

    private let fetchUserProfileUseCase: any FetchUserProfileUseCase
    private let sessionIDProvider: () -> String?

    // MARK: - Initialization

    init(
        fetchUserProfileUseCase: any FetchUserProfileUseCase,
        sessionIDProvider: @escaping () -> String? = {
            KeychainManager.shared.read(for: .sessionId)
        }
    ) {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
        self.sessionIDProvider = sessionIDProvider
    }

    // MARK: - Load

    func load() async {
        guard let sessionID = sessionIDProvider(),
              !sessionID.isEmpty else {
            state = .guest
            return
        }

        state = .loading

        do {
            let profile = try await fetchUserProfileUseCase.execute(
                sessionID: sessionID
            )
            state = .signedIn(profile)
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
