//
//  ClearUserDefaults.swift
//  UsefulMap
//
//  Created by Eduard on 04.12.2022.
//

import Foundation

class ClearUserDefaults {
    
    func clear(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
