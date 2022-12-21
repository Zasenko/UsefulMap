//
//  LaunchView.swift
//  UsefulMap
//
//  Created by Eduard on 03.12.2022.
//

import SwiftUI

struct LaunchView: View {
    
    //MARK: - Properties
    
    @StateObject var viewModel = LaunchViewModel()

    //MARK: - Body
    
    var body: some View {
        if viewModel.isAnimationOnLaunchViewEnded {
            if viewModel.isFirstTime {
                AboutAppView()
            } else {
                AuthenticationView()
            }
        } else {
            LaunchAnimationView(isAnimationOnLaunchViewEnded: $viewModel.isAnimationOnLaunchViewEnded)
        }
    }
}

