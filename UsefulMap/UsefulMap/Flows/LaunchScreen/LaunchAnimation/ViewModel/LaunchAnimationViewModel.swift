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
    @Published var logoTextSize: CGRect = CGRect()
    
    let timeForRoutate: Double = 1
    let logoSize: CGFloat = SizesConstants.logoSize
    let textHeightInLogo: CGFloat = SizesConstants.textHeightInLogo
    let textOffsetFromLogo: CGFloat = SizesConstants.textOffsetFromLogo
    let rotationAngle:CGFloat = 20
    let decreaseLogo: CGFloat = 3
    
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
    
    func calculateOffsetOfLogoAtEnd() -> CGFloat {
        -((logoSize+logoTextSize.width+textOffsetFromLogo)/2 - logoSize/2)
    }
    
    func calculateOffsetTextAtEnd() -> CGFloat {
        logoSize/2
    }
    
    func calculateOffsetTextOnStartup() -> CGFloat {
        -(logoTextSize.width + calculateOffsetOfLogoAtEnd())
    }
    
    func calculateOffsetRectangeForHideAtEnd() -> CGFloat {
        -(logoTextSize.width + abs(calculateOffsetOfLogoAtEnd()))
    }
}
