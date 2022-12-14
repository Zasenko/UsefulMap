//
//  LaunchAnimationViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import SwiftUI

class LaunchAnimationViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Binding var isAnimationOnLaunchViewEnded: Bool
    
    @Published var enlargeAndRotateLogo = false
    @Published var rotateLogo = false
    @Published var moveLogoAndShowAppName = false
    @Published var showAppName = false
    
    let timeForRoutate: Double = 1
    
    //MARK: - Initialization
    
    init(isAnimationOnLaunchViewEnded: Binding<Bool>) {
        _isAnimationOnLaunchViewEnded = isAnimationOnLaunchViewEnded
    }
}

extension LaunchAnimationViewModel {
    
    //MARK: - Functions
    
    func startAnimation() {
        withAnimation(Animation.easeInOut(duration: timeForRoutate)) {
            enlargeAndRotateLogo = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + timeForRoutate) {
            withAnimation(Animation.easeInOut(duration: self.timeForRoutate/2)) {
                self.rotateLogo = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + self.timeForRoutate/2) {
                withAnimation(Animation.easeInOut(duration: self.timeForRoutate/4)) {
                    self.moveLogoAndShowAppName = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + self.timeForRoutate*2) {
                    self.isAnimationOnLaunchViewEnded = true
                }
            }
        }
    }
}
