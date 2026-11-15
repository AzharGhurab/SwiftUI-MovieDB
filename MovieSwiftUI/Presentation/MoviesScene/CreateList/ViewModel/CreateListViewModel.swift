//
//  CreateListViewModel.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Combine

// MARK: - Create List ViewModel

@MainActor
final class CreateListViewModel: ObservableObject {

    // MARK: - Limits

    static let nameLimit = 50
    static let descriptionLimit = 200

    // MARK: - Input

    @Published var name: String = "" {
        didSet {
            if name.count > Self.nameLimit {
                name = String(name.prefix(Self.nameLimit))
            }
        }
    }

    @Published var description: String = "" {
        didSet {
            if description.count > Self.descriptionLimit {
                description = String(description.prefix(Self.descriptionLimit))
            }
        }
    }

    // MARK: - State

    @Published private(set) var isSaving = false
    @Published var errorMessage: String?

    // MARK: - Dependencies

    private let createListUseCase: any CreateListUseCase
    private let sessionIDProvider: () -> String?

    // MARK: - Initialization

    init(
        createListUseCase: any CreateListUseCase,
        sessionIDProvider: @escaping () -> String? = {
            KeychainManager.shared.read(for: .sessionId)
        }
    ) {
        self.createListUseCase = createListUseCase
        self.sessionIDProvider = sessionIDProvider
    }

    // MARK: - Validation

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !isSaving
    }

    // MARK: - Counters

    var nameCounterText: String {
        "\(name.count)/\(Self.nameLimit)"
    }

    var descriptionCounterText: String {
        "\(description.count)/\(Self.descriptionLimit)"
    }

    var isNameAtLimit: Bool {
        name.count >= Self.nameLimit
    }

    var isDescriptionAtLimit: Bool {
        description.count >= Self.descriptionLimit
    }

    // MARK: - Save

    func save() async -> Bool {
        guard canSave else { return false }

        guard let sessionID = sessionIDProvider(),
              !sessionID.isEmpty else {
            errorMessage = "Please sign in to your TMDB account."
            return false
        }

        isSaving = true
        errorMessage = nil
        defer { isSaving = false }

        do {
            _ = try await createListUseCase.execute(
                name: name,
                description: description,
                sessionID: sessionID
            )
            return true
        } catch is CancellationError {
            return false
        } catch let error as URLError where error.code == .cancelled {
            return false
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
