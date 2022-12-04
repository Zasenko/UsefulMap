//
//  LogoSubView.swift
//  UsefulMap
//
//  Created by Eduard on 03.12.2022.
//

import Foundation
import SwiftUI

struct LogoSubView: View {
    
    let logoSize = GlobalProperties().logoSize
    
    var body: some View {
        VStack{
            Spacer().frame(height:20)
            HStack{
                Spacer()
                Image("LogoWithoutText")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .shadow(radius: 15)
                    .frame(width: logoSize, height: logoSize)
                Image("LogoWithoutImage (black text)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: logoSize*0.65)
                Spacer()
            }
        }
    }
}
