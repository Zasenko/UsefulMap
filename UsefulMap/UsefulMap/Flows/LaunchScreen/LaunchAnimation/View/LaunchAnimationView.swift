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
    
    //MARK: - Initialization
    
    init(isAnimationOnLaunchViewEnded: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: LaunchAnimationViewModel(isAnimationOnLaunchViewEnded: isAnimationOnLaunchViewEnded))
    }
        
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Group {
                AppImages.logoWithoutImageWithWhiteText
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: viewModel.textHeightInLogo)
                    .background(GeometryGetter(rect: $viewModel.logoTextSize))
                    .offset(x: viewModel.moveLogoAndShowAppName ? viewModel.calculateOffsetTextAtEnd() : viewModel.calculateOffsetTextOnStartup(), y: 0)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: viewModel.logoTextSize.width, height: viewModel.logoTextSize.height, alignment: .center)
                    .offset(x: viewModel.moveLogoAndShowAppName ? viewModel.calculateOffsetRectangeForHideAtEnd() : viewModel.calculateOffsetTextOnStartup(), y: 0)
                VStack {
                    AppImages.logoWithoutText
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: viewModel.enlargeAndRotateLogo ? viewModel.logoSize : viewModel.logoSize/viewModel.decreaseLogo,
                               maxHeight: viewModel.enlargeAndRotateLogo ? viewModel.logoSize : viewModel.logoSize/viewModel.decreaseLogo)
                        .rotationEffect(viewModel.enlargeAndRotateLogo ? Angle(degrees: -viewModel.rotationAngle) : Angle(degrees: viewModel.rotationAngle))
                        .rotationEffect(viewModel.rotateLogo ? Angle(degrees: viewModel.rotationAngle) : Angle(degrees: -viewModel.rotationAngle))
                        .offset(x: viewModel.moveLogoAndShowAppName ? viewModel.calculateOffsetOfLogoAtEnd() : 0, y: 0)
                }//-VStack
            }//-Group
            .padding(.bottom, viewModel.logoSize)
            .onAppear(){
                viewModel.startAnimation()
            }//-onAppear
        }//-ZStack
    }//-body
}
