//
//  CachedImageView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 21.12.22.
//

import SwiftUI

struct CachedImageView: View {
    
    //MARK: - Properties
    
    @StateObject var viewModel: CachedImageViewModel
    
    //MARK: - Body
    
    var body: some View {
        switch viewModel.currentState {
        case .loading:
            ProgressView()
                .task {
                    await viewModel.load()
                }
        case .success, .failed:
            viewModel.image
                .resizable()
                .scaledToFill()
                .transition(.scale.combined(with: .opacity))
                .animation(.interactiveSpring(), value: viewModel.currentState)
        }
    }
}
