//
//  CachedImageViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 21.12.22.
//

import SwiftUI

class CachedImageViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var currentState: LoadingState = .loading
    @Published var image: Image = AppImages.logoWithoutText
    let url: String
    
    //MARK: - Initialization
    
    init(url: String) {
        self.url = url
    }
}

extension CachedImageViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func load(imageRetriver: ImageLoader = .shared) async {
        do {
            self.image = try await imageRetriver.loadImage(url: url)
            currentState = .success
            return
        }
        catch {
            currentState = .failed
        }
    }
}
