//
//  LaunchAnimationView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import SwiftUI

struct LaunchAnimationView: View {
    
    //MARK: - Properties
    
    @State var enlargeAndRotateLogo = false
    @State var rotateLogo = false
    @State var moveLogoAndShowAppName = false
    @State var showAppName = false
    @Binding var isAnimationOnLaunchViewEnded: Bool
    
    let logoSize: CGFloat = SizesConstants.logoSize
    let decreaseLogo: CGFloat = 3
    let increaseForAppName: CGFloat = 3
    let timeForRoutate: Double = 1
        
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Group {
                Image("LogoWithoutImage (white text)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: logoSize*0.65)
                    .offset(x: moveLogoAndShowAppName ? logoSize*increaseForAppName/6 : -logoSize*(increaseForAppName-0.5), y: 0)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: logoSize*increaseForAppName, height: logoSize, alignment: .center)
                    .offset(x: -logoSize*(increaseForAppName-0.5) , y: 0)
                VStack {
                    Image("LogoWithoutText")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: enlargeAndRotateLogo ? logoSize : logoSize/decreaseLogo, maxHeight: enlargeAndRotateLogo ? logoSize : logoSize/decreaseLogo)
                        .rotationEffect(enlargeAndRotateLogo ? Angle(degrees: -20) : Angle(degrees: 20))
                        .rotationEffect(rotateLogo ? Angle(degrees: 20) : Angle(degrees: -20))
                        .offset(x: moveLogoAndShowAppName ? -logoSize*1.5 : 0, y: 0)
                }
            }
            .padding(.bottom, logoSize)
            .onAppear(){
                withAnimation(Animation.easeInOut(duration: timeForRoutate)) {enlargeAndRotateLogo = true }
                DispatchQueue.main.asyncAfter(deadline: .now()+timeForRoutate) {
                    withAnimation(Animation.easeInOut(duration: timeForRoutate/2)) {rotateLogo = true }
                    DispatchQueue.main.asyncAfter(deadline: .now()+timeForRoutate/2) {
                        withAnimation(Animation.easeInOut(duration: timeForRoutate/4)) {moveLogoAndShowAppName = true }
                        DispatchQueue.main.asyncAfter(deadline: .now()+timeForRoutate*2) {
                            isAnimationOnLaunchViewEnded = true
                        }
                    }
                }
            }
        }
    }
}
