//
//  ListDetailsViewModel.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 04/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Combine

// MARK: - List Details ViewModel

@MainActor
final class ListDetailsViewModel: ObservableObject {

    // MARK: - State

    enum State: Equatable {
        case loading
        case loaded(UserListDetails)
        case failed(String)
    }

    @Published private(set) var state: State = .loading

    // MARK: - Properties

    let list: UserList

    // MARK: - Dependencies

    private let fetchListDetailsUseCase: any FetchListDetailsUseCase
    private let sessionIDProvider: () -> String?

    // MARK: - Initialization

    init(
        list: UserList,
        fetchListDetailsUseCase: any FetchListDetailsUseCase,
        sessionIDProvider: @escaping () -> String? = {
            KeychainManager.shared.read(for: .sessionId)
        }
    ) {
        self.list = list
        self.fetchListDetailsUseCase = fetchListDetailsUseCase
        self.sessionIDProvider = sessionIDProvider
    }

    // MARK: - Load

    func load() async {
        guard let sessionID = sessionIDProvider(),
              !sessionID.isEmpty else {
            state = .failed("Please sign in to your TMDB account.")
            return
        }

        if case .loaded = state {
        } else {
            state = .loading
        }

        do {
            let details = try await fetchListDetailsUseCase.execute(
                listID: list.id,
                sessionID: sessionID
            )
            state = .loaded(details)
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
