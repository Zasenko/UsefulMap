//
//  LogoSubView.swift
//  UsefulMap
//
//  Created by Eduard on 03.12.2022.
//

import Foundation
import SwiftUI

struct LogoSubView: View {
    
    //MARK: - Properties
    
    let logoSize = SizesConstants.logoSize
    
    //MARK: - Body
    
    var body: some View {
        VStack{
            Spacer().frame(height:20)
            HStack{
                Spacer()
                AppImages.logoWithoutText
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .shadow(radius: 15)
                    .frame(width: logoSize, height: logoSize)
                AppImages.logoWithoutImageBlackText
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: logoSize*0.65)
                Spacer()
            }
        }
    }
}
