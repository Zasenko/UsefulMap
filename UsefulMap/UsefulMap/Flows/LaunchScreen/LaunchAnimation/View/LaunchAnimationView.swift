//
//  LaunchAnimationView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import SwiftUI

struct LaunchAnimationView: View {
    
    //MARK: - Properties
    
    @StateObject var viewModel: LaunchAnimationViewModel
    
    let logoSize: CGFloat = SizesConstants.logoSize
    let decreaseLogo: CGFloat = 3
    let increaseForAppName: CGFloat = 3
    
    //MARK: - Initialization
    
    init(isAnimationOnLaunchViewEnded: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: LaunchAnimationViewModel(isAnimationOnLaunchViewEnded: isAnimationOnLaunchViewEnded))
    }
        
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Group {
                AppImages.logoWithoutImageWhiteText
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: logoSize*0.65)
                    .offset(x: viewModel.moveLogoAndShowAppName ? logoSize*increaseForAppName/6 : -logoSize*(increaseForAppName-0.5), y: 0)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: logoSize*increaseForAppName, height: logoSize, alignment: .center)
                    .offset(x: -logoSize*(increaseForAppName-0.5) , y: 0)
                VStack {
                    AppImages.logoWithoutText
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: viewModel.enlargeAndRotateLogo ? logoSize : logoSize/decreaseLogo,
                               maxHeight: viewModel.enlargeAndRotateLogo ? logoSize : logoSize/decreaseLogo)
                        .rotationEffect(viewModel.enlargeAndRotateLogo ? Angle(degrees: -20) : Angle(degrees: 20))
                        .rotationEffect(viewModel.rotateLogo ? Angle(degrees: 20) : Angle(degrees: -20))
                        .offset(x: viewModel.moveLogoAndShowAppName ? -logoSize*1.5 : 0, y: 0)
                }//-VStack
            }//-Group
            .padding(.bottom, logoSize)
            .onAppear(){
                viewModel.startAnimation()
            }//-onAppear
        }//-ZStack
    }//-body
}
