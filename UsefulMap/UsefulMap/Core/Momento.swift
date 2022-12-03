//
//  Momento.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 01.12.22.
//

import Foundation

typealias Memento = Data

final class Momento {
    
    //MARK: - Private properties
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let key = "user"
}

extension Momento {
    
    //MARK: - Functions
    
    func save(user: User) {
        do {
            let data = try self.encoder.encode(user)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func loaduser() -> User {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return User()
        }
        do {
            return try self.decoder.decode(User.self, from: data)
        } catch {
            debugPrint(error)
            return User()
        }
    }
}
