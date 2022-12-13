//
//  LaunchView.swift
//  UsefulMap
//
//  Created by Eduard on 03.12.2022.
//

import SwiftUI

struct LaunchView: View {
    
    //MARK: - Properties

    @State var isAnimationOnLaunchViewEnded = false
    @AppStorage("isFirstTime") var isFirstTime: Bool = true

    //MARK: - Body
    
    var body: some View {
        if isAnimationOnLaunchViewEnded {
            if isFirstTime {
                AboutAppView()
            } else {
                AutentificationView()
            }
        } else {
            LaunchAnimationView(isAnimationOnLaunchViewEnded: $isAnimationOnLaunchViewEnded)
        }
    }
}

