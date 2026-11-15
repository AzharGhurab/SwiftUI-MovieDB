//
//  CreateListFlowView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Create List Flow View

struct CreateListFlowView: View {

    // MARK: - Properties

    @StateObject private var viewModel: CreateListViewModel
    @Environment(\.dismiss) private var dismiss

    private let onCreated: () -> Void

    // MARK: - Initialization

    init(
        viewModel: @autoclosure @escaping () -> CreateListViewModel,
        onCreated: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.onCreated = onCreated
    }

    // MARK: - Body

    var body: some View {
        CreateListView(
            name: $viewModel.name,
            description: $viewModel.description,
            nameCounterText: viewModel.nameCounterText,
            descriptionCounterText: viewModel.descriptionCounterText,
            isNameAtLimit: viewModel.isNameAtLimit,
            isDescriptionAtLimit: viewModel.isDescriptionAtLimit,
            canSave: viewModel.canSave,
            isSaving: viewModel.isSaving,
            errorMessage: viewModel.errorMessage,
            onSave: save
        )
    }

    // MARK: - Actions

    private func save() {
        Task {
            let created = await viewModel.save()

            if created {
                onCreated()
                dismiss()
            }
        }
    }
}
