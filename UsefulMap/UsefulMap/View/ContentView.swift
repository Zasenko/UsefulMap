//
//  ContentView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties

    @AppStorage("isFirstTime") var isFirstTime: Bool = true
    
    //MARK: - Body

    var body: some View {
        if isFirstTime {
            AboutAppView()
        } else {
            AutentificationView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
