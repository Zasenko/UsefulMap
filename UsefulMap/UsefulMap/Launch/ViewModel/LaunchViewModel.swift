//
//  LaunchViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import SwiftUI

class LaunchViewModel: ObservableObject {
    
    //MARK: - Properties

    @Published var isAnimationOnLaunchViewEnded = false
    @AppStorage("isFirstTime") var isFirstTime: Bool = true
}
